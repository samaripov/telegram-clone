Rails.application.routes.draw do
  root "users#show"
  devise_for :users
  resources :users, only: [ :index, :show ]
  resources :messages
  get "chat/:sender_id/:receiver_id", to: "messages#chat", as: "chat"
end
