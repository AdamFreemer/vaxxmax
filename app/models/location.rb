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
      user_location = Geocoder.search(user_location)
      distance = Geocoder::Calculations.distance_between([user_location.first.coordinates[0], user_location.first.coordinates[1]], [location.latitude.to_f, location.longitude.to_f ])
      distance.to_i
    rescue
      'N/A'
    end
  end
end
