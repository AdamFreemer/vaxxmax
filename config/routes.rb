Rails.application.routes.draw do
  root to: "locations#index"
  resources :locations
  get 'update_records', to: 'locations#update_records'
  get 'logs', to: 'update_logs#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
