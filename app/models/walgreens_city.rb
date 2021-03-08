class WalgreensCity < ApplicationRecord
  def distance(user_ip, location)
    begin
      return 'N/A' if user_ip.nil?

      user = User.find_or_create_by(ip: user_ip) do |user|
        uri = URI("https://pro.ip-api.com/json/#{user_ip&.chomp}\?key\=#{ENV['IP_API_KEY']}")
        response = Net::HTTP.get(uri)
        params = JSON.parse(response)

        if params['status'] == 'success'
          user.update(ip: user_ip, latitude: params['lat'],
                      longitude: params['lon'], zipcode: params['zip'], state: params['region'])
        end
      end
      @distance = Haversine.distance(
        user.latitude.to_f, user.longitude.to_f,
        location.latitude.to_f, location.longitude.to_f
      ).to_miles.to_i
    rescue StandardError
      'N/A'
    end
  end
end
