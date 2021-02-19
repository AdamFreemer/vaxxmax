class LocationsController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD'], except: [:rite_aid, :walgreens, :set_state]

  before_action :set_location, only: %i[show edit update destroy]
  before_action :set_dropdowns, only: %i[walgreens rite_aid]

  def rite_aid
    @locations = Location
                 .where(is_rite_aid: true, availability: true, state: session[:state])
                 .where('when_available > ?', DateTime.now - 2.days)

    @locations_old = Location
                     .where(is_rite_aid: true, availability: true, state: session[:state])
                     .where('when_available < ?', DateTime.now - 2.days)
  end

  def test
    @states = states
    @locations = Location
                 .where(availability: true, state: session[:state])
                 .where('when_available > ?', DateTime.now - 2.days)
    @locations_old = Location
                     .where(availability: true, state: session[:state])
                     .where('when_available < ?', DateTime.now - 2.days)
  end

  def show; end;
  def walgreens
    @locations = Location.where(store_name: 'Walgreens', availability: true, state: session[:state])
                 
  end

  def show; end

  def new
    @location = Location.new
  end

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

  def update_records
    LocationUpdateJob.perform_async(true)
  end

  def set_state
    session[:state] = params[:state]
    redirect_to rite_aid_path
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def set_dropdowns
    @states_rite_aid = states_rite_aid
    @states_walgreens = ['PA']
    @providers = ['Rite Aid - Nationwide Locations', 'Walgreens - Pennsylvania']
  end

  def states_rite_aid
    %w[CA CT DE ID MA MD MI NH NJ NV NY OH OR PA VA VT WA]
  end

  # Only allow a list of trusted parameters through.
  def location_params
    params.fetch(:location, {})
  end
end
