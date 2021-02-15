class Location < ApplicationRecord
  def google_search
    "https://www.google.com/maps/search/?api=1&query=#{CGI.escape full_address.force_encoding('ASCII-8BIT')}+Rite+Aid"
  end
end
