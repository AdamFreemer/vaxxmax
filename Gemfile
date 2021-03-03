source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'
gem 'barnes'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'google-analytics-rails', '1.1.1'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'net-http-persistent'
gem 'pg'
gem 'puma', '~> 5.0'
gem 'puma_worker_killer'
gem 'rails', '~> 6.1.1'
gem 'rack-attack'
gem 'sass-rails', '>= 6'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sidekiq', '~> 6.1.0'
gem 'sqreen', '>= 1.16'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'derailed_benchmarks'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'stackprof'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
