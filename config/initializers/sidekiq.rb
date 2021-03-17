# config/initializers/sidekiq.rb
if Rails.env != "development"

  Sidekiq.configure_client do |config|
    config.redis = {url: ENV["HEROKU_REDIS_BLUE_URL"] }
  end

  Sidekiq.configure_server do |config|
    config.redis = {url: ENV["HEROKU_REDIS_BLUE_URL"] }
  end
end
