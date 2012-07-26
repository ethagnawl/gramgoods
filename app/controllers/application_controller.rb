class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  protect_from_forgery
  before_filter :clear_gon
  before_filter :set_gon
  before_filter :basic_authentication

  def after_sign_in_path_for(resource)
    stores_path
  end

  private

  def render_product_widget_template(store, product)
    {
      :name => product.name,
      :truncated_name => truncate(product.name, :length => 38),
      :url => "/stores/#{store.slug}/products/#{product.slug}",
      :description => truncate(product.description, :length => 45),
      :status => product.status,
      :flatrate_shipping_cost => product.flatrate_shipping_cost.nil? ? nil : number_to_currency(product.flatrate_shipping_cost),
      :sizes => product.sizes ||= nil,
      :colors => product.colors ||= nil,
      :product_count => "#{product.photos_array.length} #{(product.photos_array.length > 1 ? 'Photos' : 'Photo')}",
      :product_photo => product.photos_array.first,
      :price => number_to_currency(product.price)
    }
  end

  def user_owns_store?(store_id)
    current_user.store_ids.include?(store_id)
  end

  def render_conditional_layout(layout = nil)
    if user_signed_in?
      render :layout => (layout.nil? ? 'admin' : layout)
    else
      render :layout => 'mobile'
    end
  end

  def set_gon
    gon.page = "#{params[:controller]}_#{params[:action]}"
  end

  def clear_gon
    gon.clear
  end

  def basic_authentication
    authenticate_or_request_with_http_basic do |username, password|
      username == "GramG00ds" && password == "0ct@n3"
    end
  end
end
