class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  protect_from_forgery
  before_filter :clear_gon
  before_filter :set_gon
  before_filter :ensure_proper_protocol
  before_filter :basic_authentication
  helper_method :render_user_photo_template
  helper_method :mobile_device?

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

      json.instagram_tags product.instagram_tag.split(',').join(', ')
      json.colors !product.colors.nil? ? product.colors.split(',').join(', ') : nil
      json.sizes !product.sizes.nil? ? product.sizes.split(',').join(', ') : nil

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

  def basic_authentication
    if ENV['use_basic_authentication'] == 'true'
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

  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end
end
