Gramgoods::Application.routes.draw do
  root :to => 'products#index'

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :products
  resources :authentications
  resources :stores do
    post 'proxy', :on => :collection
    get 'welcome', :on => :member
    get 'return_policy', :on => :member

    resources :orders do
      get 'confirmation', :on => :member
      resources :line_items
      resources :recipients
    end
    resources :products
  end
  resources :users do
    resources :stores
  end

  get '/tos' => 'static#tos'
  get "/delayed_job" => DelayedJobWeb, :anchor => false
  get '/fetch_instagram_feed_for_user' => 'application#fetch_instagram_feed_for_user'
  get '/:id' => 'stores#show', :as => 'custom_store'
  get '/:id/edit' => 'stores#edit', :as => 'custom_store_edit'
  get '/:store_id/:id' => 'products#show', :as => 'custom_product'
  get '/:store_id/:id/edit' => 'products#edit', :as => 'custom_product_edit'
end
