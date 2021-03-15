require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'locations#riteaid'

  get 'riteaid', to: 'locations#riteaid'
  get 'rite_aid', to: 'locations#riteaid'
  get 'walgreens', to: 'locations#walgreens'
  get 'cvs', to: 'locations#cvs'
  get 'set_zipcode/:zipcode', to: 'locations#set_zipcode'

  get 'set_state_rite_aid/:state_rite_aid/:zipcode', to: 'locations#set_state_rite_aid'
  get 'set_state_walgreens/:state_walgreens', to: 'locations#set_state_walgreens'
  get 'set_state_cvs/:state_cvs', to: 'locations#set_state_cvs'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
  end
  mount Sidekiq::Web, at: '/sidekiq'

  get 'logs', to: 'update_logs#index'
  get 'test', to: 'locations#test'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
