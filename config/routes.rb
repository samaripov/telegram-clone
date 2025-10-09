Rails.application.routes.draw do
  root "users#show"
  devise_for :users
  resources :users, only: [ :index, :show ]
  resources :chats, only: [ :new, :create, :show, :destroy ] do
    resources :messages, only: [ :create, :destroy ]
  end
end
