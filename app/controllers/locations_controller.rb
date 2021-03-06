class LocationsController < ApplicationController
  # http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD'], except: [:'riteaid, :walgreens, :set_state]

  before_action :set_location, only: %i[show edit update destroy]
  before_action :set_dropdowns, only: %i[walgreens riteaid]
  before_action :geolocate, only: %i[walgreens riteaid]

  def riteaid
    @locations = Location
                 .where(is_rite_aid: true, availability: true, state: session[:state_rite_aid])
                 .where('when_available > ?', DateTime.now - 2.days)

    @locations_old = Location
                     .where(is_rite_aid: true, availability: true, state: session[:state_rite_aid])
                     .where('when_available < ?', DateTime.now - 2.days)
  end

  def walgreens
    @locations = WalgreensCity.where(state: session[:state_walgreens], availability: true)
  end

  def test
    @states = states_rite_aid
    @locations = Location
                 .where(availability: true, state: session[:state_rite_aid])
                 .where('when_available > ?', DateTime.now - 2.days)
    @locations_old = Location
                     .where(availability: true, state: session[:state_rite_aid])
                     .where('when_available < ?', DateTime.now - 2.days)
  end

  def new
    @location = Location.new
  end

  def show; end

  def geolocate
    @user_ip = if request.remote_ip == '127.0.0.1'
                 '69.242.71.104'
               else
                 request.env["HTTP_X_FORWARDED_FOR"]
               end

  end

  def set_state_rite_aid
    # binding.pry
    session[:state_rite_aid] = params[:state_rite_aid]

    redirect_to riteaid_path
  end

  def set_state_walgreens
    session[:state_walgreens] = params[:state_walgreens]

    redirect_to walgreens_path
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def set_dropdowns
    @states_rite_aid = states_rite_aid
    @states_walgreens = states_walgreens
    @providers = ['Rite Aid - Nationwide Locations', 'Walgreens - Nationwide Locations']
  end

  def states_rite_aid
    Location.where(is_rite_aid: true).order(:state).distinct.pluck(:state)
  end

  def states_walgreens
    WalgreensCity.order(:state).distinct.pluck(:state)
  end
end
