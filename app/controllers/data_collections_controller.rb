class DataCollectionsController < ApplicationController
  protect_from_forgery with: :null_session

  def cvs_ingest
    LocationUpdateJob.cvs_parse(params[:payload], params[:state])
    puts "--- data: #{params.to_json}"
    head :ok
  end
end
