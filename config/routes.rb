Rails.application.routes.draw do
  root to: 'locations#riteaid'

  get 'riteaid', to: 'locations#riteaid'
  get 'walgreens', to: 'locations#walgreens'
  get 'logs', to: 'update_logs#index'
  get 'test', to: 'locations#test'
  get 'set_state_rite_aid/:state_rite_aid', to: 'locations#set_state_rite_aid'
  get 'set_state_walgreens/:state_walgreens', to: 'locations#set_state_walgreens'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
