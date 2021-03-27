class LocationsController < ApplicationController
  # http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD'], except: [:'riteaid, :walgreens, :set_state]
  before_action :set_location, only: %i[show edit update destroy]
  before_action :geolocate, only: %i[cvs health_mart riteaid walgreens walmart]

  def cvs
    @title = 'CVS'
    @states = states_cvs.sort { |a, b| a <=> b }
    @locations = CvsCity.where(state: session[:state_cvs], availability: true)
  end

  def health_mart
    @title = 'Health Mart'
    @states = states_health_mart.sort { |a, b| a <=> b }
    @locations = HealthMartCity.where(state: session[:state_health_mart], availability: true)
  end

  def riteaid
    @title = 'Rite Aid'
    @states = states_rite_aid.sort { |a, b| a <=> b }
    @locations = Location
                 .where(is_rite_aid: true, availability: true, state: session[:state_rite_aid])
                 .where('when_available > ?', DateTime.now - 2.days)

    @locations_old = Location
                     .where(is_rite_aid: true, availability: true, state: session[:state_rite_aid])
                     .where('when_available < ?', DateTime.now - 2.days)
  end

  def walgreens
    @title = 'Walgreens'
    @states = states_walgreens.sort { |a, b| a <=> b }
    @locations = WalgreensCity.where(state: session[:state_walgreens], availability: true)
  end

  def walmart
    @title = 'Walmart'
    @states = states_walmart.sort { |a, b| a <=> b }
    @locations = WalmartCity.where(state: session[:state_walmart], availability: true)
  end

  def geolocate
    @user_ip = if request.remote_ip == '127.0.0.1' || request.remote_ip == '::1'
                 '100.14.167.116'
               else
                 request.remote_ip
               end
  end

  def set_state_rite_aid
    session[:state_rite_aid] = params[:state_rite_aid]
    session[:zipcode]= params[:zipcode]
    redirect_to riteaid_path
  end

  def set_state_walgreens
    session[:state_walgreens] = params[:state_walgreens]

    redirect_to walgreens_path
  end

  def set_state_walmart
    session[:state_walmart] = params[:state_walmart]

    redirect_to walmart_path
  end

  def set_state_cvs
    session[:state_cvs] = params[:state_cvs]

    redirect_to cvs_path
  end

  def set_state_health_mart
    session[:state_health_mart] = params[:state_health_mart]

    redirect_to health_mart_path
  end

  def set_zipcode
    session[:zipcode] = params[:zipcode]

    redirect_to riteaid_path
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def states_health_mart
    HealthMartCity.order(:state).distinct.pluck(:state)
  end

  def states_rite_aid
    Location.where(is_rite_aid: true).order(:state).distinct.pluck(:state)
  end

  def states_walgreens
    WalgreensCity.order(:state).distinct.pluck(:state)
  end

  def states_walmart
    WalmartCity.order(:state).distinct.pluck(:state)
  end

  def states_cvs
    [ 'AL', 'AK', 'AS', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC',
      'FM', 'FL', 'GA', 'GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS',
      'KY', 'LA', 'ME', 'MH', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO',
      'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'MP',
      'OH', 'OK', 'OR', 'PW', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN',
      'TX', 'UT', 'VT', 'VI', 'VA', 'WA', 'WV', 'WI', 'WY'
    ]
  end
end
