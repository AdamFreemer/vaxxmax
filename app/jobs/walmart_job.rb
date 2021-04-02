class WalmartJob
  class << self
    def process
      states.each do |state|
        uri = URI.parse("https://www.vaccinespotter.org/api/v0/states/#{state}.json")
        request = Net::HTTP::Persistent.new
        begin
          
          response = request.request uri
          data = JSON.parse(response.body)
          puts "processing #{state}..."
          process_state(state, data['features'])
        rescue StandardError => e
          puts "-- FAILURE Walmart | State: #{state} |#{e}"
        end
      end
    end

    def process_state(state, data_set)
      data_set.each do |feature|
        if feature['properties']['provider'] == 'walmart'
          location = Location.find_by(is_walmart: true, store_number: feature['properties']['provider_location_id'].to_i)
          next if location.blank?

          if feature['properties']['appointments_available'] == true
            location.increment!(:appointments_all)
            location.increment!(:appointments) if location.availability.blank?
            location.last_updated = DateTime.now
            location.when_available = DateTime.now if location.availability.blank?
            location.availability = true
            History.create!(
              location_id: location.id,
              status: true,
              is_walmart: true,
              latitude: location&.latitude,
              longitude: location&.longitude,
              city: location&.name,
              state: location&.state,
              zip: location&.zip,
              last_updated: location&.last_updated,
              when_available: location&.when_available
            )
          else
            next if location.blank?

            location.availability = false
            location.last_updated = DateTime.now
          end
          location.save

          puts "-- SUCCESS Walmart | #{location.availability} | #{location.state} | #{location.name} | #{location.zip}"
        end
      end
    end

    def states
      [ 'AL', 'AK', 'AS', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC',
        'FM', 'FL', 'GA', 'GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS',
        'KY', 'LA', 'ME', 'MH', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO',
        'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'MP',
        'OH', 'OK', 'OR', 'PW', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN',
        'TX', 'UT', 'VT', 'VI', 'VA', 'WA', 'WV', 'WI', 'WY'
      ]
    end
  end
end
