class LocationUpdateJob
  class << self
    # CA, CT, DE, ID, MA, MD, MI, NH, NJ, NV, NY, OH, OR, PA, VA, VT, WA
    def update_locations_north_east
      execute_update('NY')
      execute_update('NJ')
      execute_update('CT')
      execute_update('MA')
      execute_update('NH')
      execute_update('VT')
    end

    def update_locations_mid_atlantic
      execute_update('PA')
      execute_update('DE')
      execute_update('MD')
    end

    def update_locations_west
      execute_update('CA')
      execute_update('NV')
    end

    def update_locations_north_west
      execute_update('WA')
      execute_update('ID')
      execute_update('OR')
    end

    def update_locations_midwest
      execute_update('OH')
      execute_update('MI')
      execute_update('VA')
    end

    def execute_update(state)
      @locations = Location.where(state: state)
      @locations.each_with_index do |location, i|
        sleep(3) if i.to_s.include? '99'
        uri = URI("https://www.riteaid.com/services/ext/v2/vaccine/checkSlots?storeNumber=#{location.store_number}")
        @http = Net::HTTP::Persistent.new
        response = @http.request uri
        data = JSON.parse(response.body)
        puts "-- Index: #{i} - State: #{state} - Location: #{location.id} - id: #{location.store_number} #{data}"

        location.status = data['Status']
        location.slot_1 = !(data['Data']['slots']['1'] == false)
        location.slot_2 = !(data['Data']['slots']['2'] == false)
        location.last_updated = DateTime.now
        if location.slot_1 || location.slot_2
          location.availability = true
          location.when_available = DateTime.now
        end
        location.save
        response.body
      end
      @http.shutdown
    end
  end
end
