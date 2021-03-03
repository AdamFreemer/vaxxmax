# frozen_string_literal: true
class Rack::Attack
  Rack::Attack.throttle('requests by ip', limit: 30, period: 900) do |request|
    request.ip
  end
end
