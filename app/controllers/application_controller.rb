class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  protect_from_forgery
  before_filter :sign_in_using_token
  before_filter :clear_gon
  before_filter :set_gon
  before_filter :ensure_proper_protocol
  before_filter :basic_authentication
  helper_method :render_user_photo_template
  helper_method :mobile_device?
  helper_method :mobile_device_is_iOS?
  helper_method :user_owns_store?

  def after_sign_in_path_for(resource)
    unless current_user.first_store.nil?
      store = current_user.first_store

      if current_user.is_a_new_user?
        flash[:notice] = "#{store.name} has been created successfully. <br /> Be sure to add http://gramgoods.com/#{store.slug} to your Instagram profile.".html_safe
        new_store_product_path(store)
      else
        flash[:notice] = "Signed in successfully as #{current_user.username}."
        custom_store_path(store)
      end
    else
      new_store_path
    end
  end

  def after_sign_out_path_for(resource)
    cookies['destroy_localStorage_auth_token'] = true
    super
  end

  def _get_instagram_feed_for_user_and_filter_by_tag
    tag = params[:tag]
    store = params[:store_slug]
    user = Store.find(store).user
    user_feed = view_context.get_instagram_feed_for_user_and_filter_by_tag(user, tag)
    if user_feed && user_feed.length > 0
      render :json => {
        :status => 'success',
        :product_images => user_feed.map { |image| image[:url] },
        :like_count => user_feed.inject(0) { |sum, image| image[:like_count] }
      }
    else
      render :json => {
        :status => 'error',
        :alert => 'Sorry, there don\'t seem to be any more photos available.'
      }
    end
  end

  def _get_instagram_photo_feed_for_user
    max_id = params[:max_id]
    product = params[:product_slug] == '' ? nil : Product.find_by_slug(params[:product_slug])
    user_feed = view_context.get_instagram_photo_feed_for_user(current_user, max_id)
    if user_feed && user_feed.length > 0
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
    else
      render :json => {
        :status => 'error',
        :alert => 'Sorry, there don\'t seem to be any more photos available.'
      }
    end
  end

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

  private

  def render_product_widget_template(store, product)
    Jbuilder.encode do |json|
      json.name product.name
      json.truncated_name truncate(product.name, :length => 22)

      json.instagram_tag product.get_instagram_tag
      json.colors !product.colors.empty? ? product.get_colors : nil
      json.sizes !product.sizes.empty? ? product.get_sizes : nil

      json.product_slug product.slug
      json.store_slug store.slug
      json.truncated_description truncate(product.description, :length => 45)
      json.description product.description
      json.price number_to_currency(product.price)
      json.quantity product.get_quantity
      json.flatrate_shipping_cost product.flatrate_shipping_cost.nil? ? nil : number_to_currency(product.flatrate_shipping_cost)
      json.status product.status

      # configure Twitter label classes
      json._status 'warning' if product.status.gsub(' ', '-').downcase == 'draft'
      json._status 'success' if product.status.gsub(' ', '-').downcase == 'active'
      json._status 'important' if product.status.gsub(' ', '-').downcase == 'out_of_stock'
      json.product_photo_count "#{product.product_images.length} #{'Photo'.pluralize(product.product_images.length)}"
      json.product_photo !product.first_product_image.empty? ? product.first_product_image : false
      json.product_photos product.product_images.map { |product_image| render_user_photo_template(product, product_image) }
      json.product_photo_gallery_scroll product.product_images.length > 5 ? 'product-photos-gallery-scroll' : nil
    end
  end

  def user_owns_store?(store_id)
    !current_user.nil? && current_user.store_ids.include?(store_id)
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
    gon.authenticated = user_signed_in?
    gon.auth_token = if (cookies['destroy_localStorage_auth_token'] == 'true') &&
                       gon.page != 'static_index' #static_index is root_path
      # delete the cookie set after sign_out
      cookies.delete 'destroy_localStorage_auth_token'
      'destroy'
    elsif !current_user.nil?
      current_user.authentication_token
    else
      nil
    end
    gon.layout = params[:layout]
  end

  def clear_gon
    gon.clear
  end

  def basic_authentication
    if ENV['USE_BASIC_AUTHENTICATION'] == 'true'
      authenticate_or_request_with_http_basic do |username, password|
        username == "GramG00ds" && password == "00000"
      end
    end
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

  def mobile_device_is_iOS?
    mobile_device? && request.user_agent =~ /iPhone|iPad|iPod/
  end

  def mobile_device?
    return true if params[:layout] == 'mobile'
    request.user_agent =~ /Mobile|webOS/
  end

  def sign_in_using_token
    if current_user.nil?
      user = User.find_by_authentication_token('pCPq7mzquCE3CKMHnxDx')
      sign_in_and_redirect(user) unless user.nil?
    end
  end
end
