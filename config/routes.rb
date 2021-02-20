Rails.application.routes.draw do
  root to: 'locations#index'
  resources :locations

  get 'logs', to: 'update_logs#index'
  get 'set_state/:state', to: 'locations#set_state'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
