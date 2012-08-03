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

  def _get_instagram_photo_feed_for_user
    max_id = params[:max_id]
    product = params[:product_slug] == '' ? nil : Product.find_by_slug(params[:product_slug])
    user_feed = view_context.get_instagram_photo_feed_for_user(current_user, max_id)
    if user_feed.empty? || user_feed.nil?
      render :json => {
        :status => 'error',
        :alert => 'Sorry, there don\'t seem to be any more photos available.'
      }
    else
      product_photos = user_feed.map do |photo|
        render_user_photo_template(product, photo)
      end
      render :json => {
        :max_id => user_feed.last[:id],
        :product_photos => product_photos
      }
    end
  end

  private

  def render_user_photo_template(product = nil, photo)
    logger.info "????? #{photo.id}"
    selected = product.nil? ? false : product.photos_array.include?(view_context.product_photo_url(photo))
    {
      :url => view_context.product_photo_url(photo),
      :instagram_id => photo.id,
      :tags => photo.tags,
      :selected => selected ? 'selected' : nil,
      :btnClass => selected ? 'btn-success' : 'btn-inverse'
    }
  end

  def render_product_widget_template(store, product)
    {
      :name => product.name,
      :truncated_name => truncate(product.name, :length => 22),
      :instagram_tag => product.instagram_tag,
      :slug => product.slug,
      :store_slug => store.slug,
      :store_id => store.id,
      :url => "/stores/#{store.slug}/products/#{product.slug}",
      :description => truncate(product.description, :length => 45),
      :raw_description => product.description,
      :price => number_to_currency(product.price),
      :raw_price => product.price,
      :quantity => product.get_quantity,
      :raw_quantity => product.quantity,
      :unlimited_quantity => product.unlimited_quantity,
      :colors => product.colors ||= nil,
      :sizes => product.sizes ||= nil,
      :flatrate_shipping_cost => product.flatrate_shipping_cost.nil? ? nil : number_to_currency(product.flatrate_shipping_cost),
      :raw_flatrate_shipping_cost => product.flatrate_shipping_cost.nil? ? nil : product.flatrate_shipping_cost,
      :status => product.status,
      :draft => product.status == 'Draft',
      :active => product.status == 'Active',
      :out_of_stock => product.status == 'Out of Stock',
      :raw_product_photo_count => product.photos_array.length,
      :product_photo_count => "#{product.photos_array.length} #{(product.photos_array.length == 0 || product.photos_array.length > 1 ? 'Photos' : 'Photo')}",
      :product_photo => product.photos_array.first,
      :product_photos => product.photos_array.map { |photo| { :photo => photo } },
      :product_photo_gallery_scroll => product.photos_array.length > 5 ? 'product-photos-gallery-scroll' : nil
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
