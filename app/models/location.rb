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

  def distance(user_location, location)
    begin
      puts "-- (user_location, location): #{user_location} | #{location}"
      user_loc = Geocoder.search(user_location)
      puts "-- user_location: #{user_loc}"
      distance = Geocoder::Calculations.distance_between(
        [user_loc.first.coordinates[0], user_loc.first.coordinates[1]],
        [location.latitude.to_f, location.longitude.to_f ]
      )
      puts "-- distance: #{distance}"
      distance.to_i
    rescue
      'N/A'
    end
  end
end
