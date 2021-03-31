class DataCollectionsController < ApplicationController
  protect_from_forgery with: :null_session

  def cvs_ingest
    LocationUpdateJob.cvs_parse(params[:payload], params[:state])
    puts "--- data: #{params.to_json}"
    head :ok
  end

  def state_by_zipcode
    case params[:provider]
    when 'all'
      object = History.where(state: params[:state].upcase).limit(1000)
    when 'cvs'
      object = History.where(state: params[:state].upcase, is_cvs: true).limit(1000)
    when 'healthmart'
      object = History.where(state: params[:state].upcase, is_health_mart: true).limit(1000)
    when 'riteaid'
      object = History.where(state: params[:state].upcase, is_rite_aid: true).limit(1000)
    when 'walgreens'
      object = History.where(state: params[:state].upcase, is_walgreens: true).limit(1000)
    when 'walmart'
      object = History.where(state: params[:state].upcase, is_walmart: true).limit(1000)
    end

    final_object = object.as_json(only: [
      :id, :zip, :latitude, :longitude, :last_updated, :when_available
    ], methods: :provider)
    render json: final_object, status: 200
  end
end
