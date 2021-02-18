Rails.application.routes.draw do
  root to: 'locations#rite_aid'
  resources :locations, only: [:edit, :destroy]

  get 'rite_aid', to: 'locations#rite_aid'
  get 'update_records', to: 'locations#update_records'
  get 'logs', to: 'update_logs#index'
  get 'test', to: 'locations#test'
  get 'set_state/:state', to: 'locations#set_state'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
