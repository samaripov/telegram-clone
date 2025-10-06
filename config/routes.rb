Rails.application.routes.draw do
  root "messages#index"
  devise_for :users
  resources :users, only: [ :index ]
  resources :messages
end
