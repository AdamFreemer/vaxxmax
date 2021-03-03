# frozen_string_literal: true
class Rack::Attack
  Rack::Attack.blocklist('allow2ban login scrapers') do |req|
    Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 20, findtime: 1.minute, bantime: 15.minutes) do
      # The count for the IP is incremented if the return value is truthy.
      req.path == '/' and req.get?
      req.path == '/walgreens' and req.get?
      req.path == '/riteaid' and req.get?
    end
  end
end
