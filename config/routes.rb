Gramgoods::Application.routes.draw do
  devise_for :users

  root :to => "stores#index"

  resources :stores
  resources :users
end
