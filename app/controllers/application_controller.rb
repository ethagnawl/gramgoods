class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  protect_from_forgery
  before_filter :clear_gon
  before_filter :set_gon
  before_filter :ensure_proper_protocol
  helper_method :secure_url

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
      unless product.nil?
        product_photos = product_photos.reject do |product_photo|
          product.product_image_urls.include?(product_photo[:url])
        end
      end
      render :json => {
        :max_id => user_feed.last[:id],
        :product_photos => product_photos
      }
    end
  end

  private

  def render_user_photo_template(product = nil, photo)
    selected = product.nil? ? false : product.product_image_ids.include?(photo.instagram_id)
    {
      :likes => (defined?(photo[:likes][:count].to_i)).nil? ? photo[:likes] : photo[:likes][:count].to_i,
      :thumbnail => (defined?(photo[:images][:thumbnail])).nil? ? photo[:thumbnail] : photo[:images][:thumbnail][:url],
      :url => photo.url ||= view_context.product_photo_url(photo),
      :tags => photo.tags.split(',').join(' '),
      :selected => selected ? 'selected' : nil,
      :btnClass => selected ? 'btn-success' : 'btn-inverse',
      :instagram_id => photo.id
    }
  end

  def render_product_widget_template(store, product)
    Jbuilder.encode do |json|
      json.name product.name
      json.truncated_name truncate(product.name, :length => 22)
      json.instagram_tags (product.instagram_tag.split(',').map { |instagram_tag| { :instagram_tag => instagram_tag}})
      json.raw_instagram_tags product.instagram_tag
      json.slug product.slug
      json.store_slug store.slug
      json.store_id store.id
      json.url "/stores/#{store.slug}/products/#{product.slug}"
      json.description truncate(product.description, :length => 45)
      json.raw_description product.description
      json.price number_to_currency(product.price)
      json.raw_price number_with_precision(product.price, :precision => 2)
      json.quantity product.get_quantity
      json.raw_quantity product.quantity
      json.unlimited_quantity product.unlimited_quantity
      json.colors product.colors ||= nil
      json.sizes product.sizes ||= nil
      json.flatrate_shipping_cost product.flatrate_shipping_cost.nil? ? nil : number_to_currency(product.flatrate_shipping_cost)
      json.raw_flatrate_shipping_cost product.flatrate_shipping_cost.nil? ? nil : number_with_precision(product.flatrate_shipping_cost, :precision => 2)
      json.status product.status

      # configure Twitter label classes
      json._status 'warning' if product.status.gsub(' ', '-').downcase == 'draft'
      json._status 'success' if product.status.gsub(' ', '-').downcase == 'active'
      json._status 'important' if product.status.gsub(' ', '-').downcase == 'out_of_stock'
      json.draft product.status == 'Draft'
      json.active product.status == 'Active'
      json.out_of_stock product.status == 'Out of Stock'
      json.raw_product_photo_count product.product_images.length
      json.product_photo_count "#{product.product_images.length} #{'Photo'.pluralize(product.product_images.length)}"
      json.product_photo !product.first_product_image.empty? ? product.first_product_image : false
      json.product_photos product.product_images.map { |product_image| render_user_photo_template(product, product_image) }
      json.product_photo_gallery_scroll product.product_images.length > 5 ? 'product-photos-gallery-scroll' : nil
      json.store_owner_instagram store.user.authentication.nickname unless store.user.authentication.nil?
      json.store_owner_email store.user.email
    end
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
    gon.user_signed_in = user_signed_in?
    gon.environment = ENV['RAILS_ENV']
    gon.authenticated = user_signed_in? && !current_user.authentication.nil? ? true : false
    gon.layout = params[:layout]
  end

  def clear_gon
    gon.clear
  end

  def ssl_allowed_action?
    params[:controller] == 'orders' || params[:controller] == 'devise/sessions' ||
    params[:controller] == 'registrations' || params[:controller] == 'devise/passwords'
  end

  def ensure_proper_protocol
    if request.ssl? && !ssl_allowed_action?
      redirect_to "http://" + request.host + request.fullpath
    end
  end

  def secure_url(url)
    Rails.env.production? ? ENV['SECURE_HEROKU_APP_URL'] + url : url
  end
end
