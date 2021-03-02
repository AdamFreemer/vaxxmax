# As per https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server

workers Integer(ENV['WEB_CONCURRENCY'] || 6)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 8)
threads threads_count, threads_count

preload_app!

rackup            DefaultRackup
port              ENV['PORT']                       || 3000
reaping_frequency ENV['DATABASE_REAPING_FREQUENCY'] || 10
environment       ENV['RACK_ENV']                         || 'development'

before_fork do
  # Start Heroku's Ruby runtime metrics collection
  Barnes.start
end

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end