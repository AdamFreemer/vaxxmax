require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'locations#riteaid'

  # pages
  get 'cvs', to: 'locations#cvs'
  get 'health_mart', to: 'locations#health_mart'
  get 'riteaid', to: 'locations#riteaid'
  get 'rite_aid', to: 'locations#riteaid'
  get 'walgreens', to: 'locations#walgreens'
  get 'walmart', to: 'locations#walmart'
  get 'map', to: 'visualizations#main'

  # zipcode geolocate set
  get 'set_zipcode/:zipcode', to: 'locations#set_zipcode'

  # CVS api update ingest
  post 'cvs_ingest', to: 'data_collections#cvs_ingest'

  # api
  get 'api/v1/state_by_zipcode/:state/:provider', to: 'data_collections#state_by_zipcode'
  get 'api/v1/daily_by_state/:state/:provider/:day_of_year', to: 'data_collections#daily_by_state'
  get 'api/v1/daily_by_state_count/:state/:provider/:day_of_year', to: 'data_collections#daily_by_state_count'
  get 'api/v1/by_zipcode/:state/:provider/:start_day/:end_day', to: 'data_collections#by_zipcode'

  # per page select dropdowns
  get 'set_state_cvs/:state_cvs', to: 'locations#set_state_cvs'
  get 'set_state_health_mart/:state_health_mart', to: 'locations#set_state_health_mart'
  get 'set_state_rite_aid/:state_rite_aid/:zipcode', to: 'locations#set_state_rite_aid'
  get 'set_state_walgreens/:state_walgreens', to: 'locations#set_state_walgreens'
  get 'set_state_walmart/:state_walmart/:zipcode', to: 'locations#set_state_walmart'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"

  get 'logs', to: 'update_logs#index'
end
