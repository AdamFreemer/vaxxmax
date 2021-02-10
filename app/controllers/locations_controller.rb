class LocationsController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD'], except: :index

  before_action :set_location, only: %i[show edit update destroy]

  # GET /locations or /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1 or /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations or /locations.json
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

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
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
