# frozen_string_literal: true
class Rack::Attack
  Rack::Attack.throttle('requests by ip', limit: 10, period: 30.seconds, bantime: 15.minutes) do |request|
    request.ip
  end
end
