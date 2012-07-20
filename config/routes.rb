Gramgoods::Application.routes.draw do
  resources :authentications

  devise_for :users

  root :to => "stores#index"

  resources :stores
  resources :users
  match '/auth/:provider/callback' => 'authentications#create'
end
