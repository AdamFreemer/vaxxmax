class DataCollectionsController < ApplicationController
  protect_from_forgery with: :null_session

  def cvs_ingest
    LocationUpdateJob.cvs_parse(params[:payload], params[:state])
    puts "--- data: #{params.to_json}"
    head :ok
  end

  def state_by_zipcode
    if params[:provider] == 'all'
      object = History.where(state: params[:state].upcase).limit(2000).as_json(only: [
        :id, :zip, :latitude, :longitude, :last_updated, :when_available
      ], methods: :provider)
      render json: object, status: 200
    else

    end
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
