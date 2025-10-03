Rails.application.routes.draw do
  devise_for :users
  root "no_model_pages#home"
end
