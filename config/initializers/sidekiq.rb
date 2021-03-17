# config/initializers/sidekiq.rb
if Rails.env != "development"

  Sidekiq.configure_client do |config|
    config.redis = {driver: 'hiredis',  url: ENV["REDIS_URL"] }
  end

  Sidekiq.configure_server do |config|
    config.redis = {driver: 'hiredis',  url: ENV["REDIS_URL"] }
  end
end
