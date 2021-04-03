class Location < ApplicationRecord
  def google_search
    "https://www.google.com/maps/search/?api=1&query=#{CGI.escape full_address.force_encoding('ASCII-8BIT')}+Rite+Aid"
  end

  def google_search_walmart
    "https://www.google.com/maps/search/?api=1&query=#{CGI.escape full_address.force_encoding('ASCII-8BIT')}+Walmart"
  end

  def rite_aid_location_website
    st = state&.parameterize(separator: '-')
    add = address&.parameterize(separator: '-')
    cit = city&.parameterize(separator: '-')

    "https://www.riteaid.com/locations/#{st}/#{cit}/#{add}.html"
  end

  def distance(user_ip, zipcode='undefined', location)
    begin
      puts "--- #{user_ip}"
      search_location = if zipcode == 'undefined'
                          lookup_by_ip(user_ip)
                        elsif zipcode.present?
                          Zipcode.find_by(zipcode: zipcode.to_i)
                        else
                          lookup_by_ip(user_ip)
                        end

    Haversine.distance(search_location.latitude.to_f,
      search_location.longitude.to_f, location.latitude.to_f,
      location.longitude.to_f).to_miles.to_i
    rescue StandardError
      'N/A'
    end
  end

  def lookup_by_ip(user_ip)
    return false if user_ip.blank?

    User.find_or_create_by(ip: user_ip) do |user|
      uri = URI("https://pro.ip-api.com/json/#{user_ip&.chomp}\?key\=#{ENV['IP_API_KEY']}")
      response = Net::HTTP.get(uri)
      params = JSON.parse(response)

      if params['status'] == 'success'
        user.update(ip: user_ip, latitude: params['lat'],
                    longitude: params['lon'], zipcode: params['zip'], state: params['region'])
      end
    end
  end
end
