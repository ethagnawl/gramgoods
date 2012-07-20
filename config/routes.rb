Gramgoods::Application.routes.draw do
  resources :products

  resources :authentications

  devise_for :users, :controllers => { :registrations => 'registrations' }

  root :to => "stores#index"

  resources :stores do
    resources :products
  end
  resources :users
  match '/auth/:provider/callback' => 'authentications#create'
end
