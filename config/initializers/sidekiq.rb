# config/initializers/sidekiq.rb
if Rails.env != "development"

  Sidekiq.configure_server do |config|
    config.redis = {url: ENV["HEROKU_REDIS_BLUE_URL"] }
  end

  Rails.application.config.after_initialize do
    ActiveRecord::Base.connection_pool.disconnect!
    ActiveSupport.on_load(:active_record) do
      config = Rails.application.config.database_configuration[Rails.env]
      config['reaping_frequency'] = ENV['DATABASE_REAP_FREQ'] || 10 # seconds
      config['pool'] = ENV["SIDEKIQ_DATABASE_POOL_SIZE"] || 20
      puts 'config'
      puts config
      ActiveRecord::Base.establish_connection(config)
    end

  end

  Sidekiq.configure_client do |config|
    config.redis = {url: ENV["HEROKU_REDIS_BLUE_URL"] }
  end


end
