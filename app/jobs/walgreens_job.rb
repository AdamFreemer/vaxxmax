class WalgreensJob
  class << self
    def process
      states.each do |state|
        uri = URI.parse("https://www.vaccinespotter.org/api/v0/states/#{state}.json")
        request = Net::HTTP::Persistent.new
        begin
          response = request.request uri
          data = JSON.parse(response.body)
          process_state(state, data['features'])
        rescue StandardError => e

        end
      end
    end

    def process_state(state, data_set)
      data_set.each do |feature|
        zip = feature['properties']['postal_code']
        location = WalgreensCity.find_by(zip: zip)
        next if location.nil?

        if feature['properties']['provider'] == 'walgreens' && feature['properties']['appointments_available'] == true
          vaccine_types = feature['properties']['appointment_vaccine_types'].keys.join(', ').titleize
          vaccine_types.gsub!('Jj', 'J&J')

          location.increment!(:appointments_all)
          location.increment!(:appointments) if location.availability.blank?
          location.last_updated = DateTime.now
          location.when_available = DateTime.now if location.availability.blank?
          location.availability = true
          location.vaccine_types = vaccine_types
          History.create!(
            location_id: location.id,
            status: true,
            is_walgreens: true,
            latitude: location&.latitude,
            longitude: location&.longitude,
            city: location&.name,
            state: state,
            zip: location&.zip,
            last_updated: location&.last_updated,
            when_available: location&.when_available,
            vaccine_types: vaccine_types
          )
        else
          location.availability = false
          location.last_updated = DateTime.now
        end
        location.save
        puts "-- SUCCESS Walgreens | #{location.availability} | #{location.state} | #{location.name} | #{location.zip}"
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
