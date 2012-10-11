Gramgoods::Application.routes.draw do

  resources :products
  resources :authentications

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  root :to => 'static#index'
  match '/tos' => 'static#tos'

  resources :stores do
    resources :orders do
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
  match 'get_instagram_feed_for_current_user' => 'application#_get_instagram_photo_feed_for_user'
  match 'get_instagram_feed_for_user_and_filter_by_tag' => 'application#_get_instagram_feed_for_user_and_filter_by_tag'
  match 'stores_proxy' => 'stores#proxy'
  match '/:id' => 'stores#show', :as => 'custom_store'
  match '/:id/edit' => 'stores#edit', :as => 'custom_store_edit'
  match '/:store_id/:id' => 'products#show', :as => 'custom_product'
  match '/:store_id/:id/edit' => 'products#edit', :as => 'custom_product_edit'
end
