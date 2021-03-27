class WalmartCity < ApplicationRecord
  def distance(user_ip, zipcode='undefined', location)
    puts "---- WalmartCity distance | ip: #{user_ip} | zip: #{zipcode} | location: #{location}"
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
