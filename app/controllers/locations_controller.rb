class LocationsController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD'], except: [:rite_aid, :walgreens, :set_state]

  before_action :set_location, only: %i[show edit update destroy]
  before_action :set_dropdowns, only: %i[walgreens rite_aid]

  def rite_aid
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
  def edit; end

  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: "Location was successfully created." }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def set_state_rite_aid
    # binding.pry
    session[:state_rite_aid] = params[:state_rite_aid]

    redirect_to rite_aid_path
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

  # Only allow a list of trusted parameters through.
  def location_params
    params.fetch(:location, {})
  end
end
