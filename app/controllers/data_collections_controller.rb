class DataCollectionsController < ApplicationController
  protect_from_forgery with: :null_session

  def cvs_ingest
    LocationUpdateJob.cvs_parse(params[:payload], params[:state])
    puts "--- data: #{params.to_json}"
    head :ok
  end

  def cvs_data
    cvs = Location.all.pluck(:state, :zip, :last_updated, :when_available, :availability)

    json_response(cvs)
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
