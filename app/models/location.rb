class Location < ApplicationRecord
  def google_search
    "https://www.google.com/maps/search/?api=1&query=#{CGI.escape full_address.force_encoding('ASCII-8BIT')}+Rite+Aid"
  end

  def rite_aid_location_website
    st = state&.parameterize(separator: '-')
    add = address&.parameterize(separator: '-')
    cit = city&.parameterize(separator: '-')

    "https://www.riteaid.com/locations/#{st}/#{cit}/#{add}.html"
  end

  def distance(user_ip, location)
    begin
      user = User.find_or_create_by(ip: user_ip) do |user|
        uri = URI("https://pro.ip-api.com/json/#{user_ip}\?key\=#{ENV['IP_API_KEY']}")
        response = Net::HTTP.get(uri)
        params = JSON.parse(response)

        if params['status'] == 'success'
          user.update(ip: user_ip, latitude: params['lat'],
                      longitude: params['lon'], zipcode: params['zip'], state: params['region'])
        end
      end
      @distance = Haversine.distance(user.latitude.to_f, user.longitude.to_f, location.latitude.to_f, location.longitude.to_f).to_miles.to_i
    rescue StandardError
      'N/A'
    end
  end
end
