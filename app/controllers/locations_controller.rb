class LocationsController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD'], except: [:rite_aid, :walgreens, :set_state]

  before_action :set_location, only: %i[show edit update destroy]

  def rite_aid
    @states = states
    @locations = Location
                 .where(store_name: 'Rite Aid', availability: true, state: session[:state])
                 .where('when_available > ?', DateTime.now - 2.days)

    @locations_old = Location
                     .where(store_name: 'Rite Aid', availability: true, state: session[:state])
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

  def states
    %w[CA CT DE ID MA MD MI NH NJ NV NY OH OR PA VA VT WA]
  end

  def fetch
    @locations.each do |location|
      uri = URI("https://www.riteaid.com/services/ext/v2/vaccine/checkSlots?storeNumber=#{location.store_number}")
      response = Net::HTTP.get_response(uri)
      data = JSON.parse(response.body)
      puts "#{location.id} - id: #{location.store_number} #{data}"
      location.status = data['Status']
      location.slot_1 = !(data['Data']['slots']['1'] == false)
      location.slot_2 = !(data['Data']['slots']['2'] == false)
      location.save
      response.body
    end
  end

  # Only allow a list of trusted parameters through.
  def location_params
    params.fetch(:location, {})
  end
end
