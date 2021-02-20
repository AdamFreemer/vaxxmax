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
      UpdateLog.create(task: 'update_locations_north_east')
    end

    def update_locations_mid_atlantic
      execute_update('PA')
      execute_update('DE')
      execute_update('MD')
      UpdateLog.create(task: 'update_locations_mid_atlantic')
    end

    def update_locations_west
      execute_update('CA')
      execute_update('NV')
      UpdateLog.create(task: 'update_locations_west')
    end

    def update_locations_north_west
      execute_update('WA')
      execute_update('ID')
      execute_update('OR')
      UpdateLog.create(task: 'update_locations_north_west')
    end

    def update_locations_midwest
      execute_update('OH')
      execute_update('MI')
      execute_update('VA')
      UpdateLog.create(task: 'update_locations_midwest')
    end

    def execute_update(state)
      puts "-- STARTING Update Job | State: #{state}"
      @locations = Location.where(state: state)
      @locations.each_with_index do |location, i|
        sleep(3) if i.to_s.include? '99'
        uri = URI("https://www.riteaid.com/services/ext/v2/vaccine/checkSlots?storeNumber=#{location.store_number}")
        @http = Net::HTTP::Persistent.new
  
        begin
          response = @http.request uri
          data = JSON.parse(response.body)
        rescue StandardError => e
          puts "-- ERROR JSON.parse or Net:HTTP -- Location ID: #{location.id} - #{e.message}"
          data = nil
        end

        puts "-- Index: #{i} - State: #{state} - Location ID: #{location.id} - store #: #{location.store_number} #{data}"
        if data['Data'].nil?
          puts "-- ERROR : Location ID: #{location.id} - store #: #{location.store_number} #{data}"
          UpdateLog.create(task: "-- ERROR #{location.id} - store #: #{location.store_number} #{data}")
          next
        end
        location.status = data['Status']
        location.slot_1 = !(data['Data']['slots']['1'] == false)
        location.slot_2 = !(data['Data']['slots']['2'] == false)
        location.last_updated = DateTime.now
        if location.slot_1 || location.slot_2
          location.when_available = DateTime.now if location.availability.blank?
          location.store_availability_count += 1 if location.availability.blank?
          location.availability = true
        else
          location.availability = false
        end
        location.save
        response.body
      end
      @http.shutdown
      puts "-- COMPLETED Update Job | State: #{state}"
    end

    def walgreens
      binding.pry
      uri = URI('https://www.walgreens.com/hcschedulersvc/svc/v2/immunizationLocations/timeslots')
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = {
        position: {
          latitude: 40.11971279999999,
          longitude: -75.0097103
        },
        state: 'PA',
        vaccine: { productId: '' },
        appointmentAvailability: { startDateTime: '2021-02-11' },
        radius: 25,
        size: 25,
        serviceId: 99
      }.to_json
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
    end
  end
end
