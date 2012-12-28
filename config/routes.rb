Gramgoods::Application.routes.draw do

  resources :products
  resources :authentications

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  root :to => 'products#index'
  match '/tos' => 'static#tos'
  match '/use_mobile_safari' => 'static#use_mobile_safari'

  resources :stores do
    get 'welcome', :on => :member
    get 'return_policy', :on => :member

    resources :orders do
      get 'confirmation', :on => :member
      resources :line_items
      resources :recipients
    end
    resources :products do
      resources :product_images
    end
  end
  resources :users do
    resources :stores
  end
  match "/delayed_job" => DelayedJobWeb, :anchor => false
  match 'instagram_feed_for_user_filtered_by_tag' => 'application#instagram_feed_for_user_filtered_by_tag'
  match 'stores_proxy' => 'stores#proxy'
  match '/:id' => 'stores#show', :as => 'custom_store'
  match '/:id/edit' => 'stores#edit', :as => 'custom_store_edit'
  match '/:store_id/:id' => 'products#show', :as => 'custom_product'
  match '/:store_id/:id/edit' => 'products#edit', :as => 'custom_product_edit'
end
