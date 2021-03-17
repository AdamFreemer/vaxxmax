# config/initializers/sidekiq.rb
if Rails.env != "development"
  Sidekiq.configure_client do |config|
    config.redis = {driver: 'hiredis'}
  end
  
  Sidekiq.configure_server do |config|
    config.redis = {driver: 'hiredis'}
  end
end
