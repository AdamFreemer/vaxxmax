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

  def daily_by_state
    # params :state/:provider/:day_of_year
    case params[:provider]
    when 'all'
      object = History.where(state: params[:state].upcase)
    when 'cvs'
      object = History.where(state: params[:state].upcase, is_cvs: true)
    when 'healthmart'
      object = History.where(state: params[:state].upcase, is_health_mart: true)
    when 'riteaid'
      object = History.where(state: params[:state].upcase, is_rite_aid: true)
    when 'walgreens'
      object = History.where(state: params[:state].upcase, is_walgreens: true)
    when 'walmart'
      object = History.where(state: params[:state].upcase, is_walmart: true)
    end

    today_day_of_year = Date.today.yday
    query_day = today_day_of_year - params[:day_of_year].to_i
    dated_object = object.where(created_at: query_day.day.ago.beginning_of_day..query_day.day.ago.end_of_day)
    final_object = dated_object.as_json(only: [:zip, :latitude, :longitude, :created_at], methods: :provider)

    render json: final_object, status: 200
  end

  def daily_by_state_count
    # params :state/:provider/:day_of_year
    case params[:provider]
    when 'all'
      object = History.where(state: params[:state].upcase)
    when 'cvs'
      object = History.where(state: params[:state].upcase, is_cvs: true)
    when 'healthmart'
      object = History.where(state: params[:state].upcase, is_health_mart: true)
    when 'riteaid'
      object = History.where(state: params[:state].upcase, is_rite_aid: true)
    when 'walgreens'
      object = History.where(state: params[:state].upcase, is_walgreens: true)
    when 'walmart'
      object = History.where(state: params[:state].upcase, is_walmart: true)
    end

    today_day_of_year = Date.today.yday
    query_day = today_day_of_year - params[:day_of_year].to_i
    record_count = object.where(created_at: query_day.day.ago.beginning_of_day..query_day.day.ago.end_of_day).count
    final_object = {
      state: params[:state],
      provider: params[:provider],
      day_of_year: params[:day_of_year],
      records: record_count
    }

    render json: final_object, status: 200
  end




end
