class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  protect_from_forgery
  before_filter :clear_gon
  before_filter :set_gon
  before_filter :ensure_proper_protocol
  before_filter :basic_authentication

  helper_method :mobile_device?
  helper_method :browser_is_instagram?
  helper_method :mobile_device_is_iOS?
  helper_method :user_owns_store?
  helper_method :is_store_slug_in_merchants_with_custom_store_slugs_array?

  def after_sign_in_path_for(resource)
    unless current_user.first_store.nil?
      store = current_user.first_store

      if current_user.is_a_new_user?
        flash[:notice] = "#{store.name} has been created successfully. <br /> Be sure to add <a href='/#{store.slug}'>http://gramgoods.com/#{store.slug}</a> to your Instagram profile.".html_safe
        store_path(store)
      else
        flash[:notice] = "Signed in successfully as #{current_user.username}."
        custom_store_path(store)
      end
    else
      new_store_path
    end
  end

  def instagram_feed_for_user_filtered_by_tag
    tag = params[:tag]
    store = params[:store_slug]
    user = Store.find(store).user
    user_feed = user.fetch_instagram_feed_for_user_and_filter_by_tag(tag)
    if user_feed && user_feed.length > 0
      render :json => {
        :status => 'success',
        :product_images => user_feed.map { |image| image[:url] },
        :like_count => user_feed.inject(0) { |sum, image| sum + image[:like_count] }
      }
    else
      render :json => {
        :status => 'error',
        :alert => 'Sorry, there don\'t seem to be any more photos available.'
      }
    end
  end

  private
    def is_store_slug_in_merchants_with_custom_store_slugs_array?(store_slug)
      return false if !defined?(MERCHANTS_WITH_CUSTOM_STORE_SLUGS) || MERCHANTS_WITH_CUSTOM_STORE_SLUGS.nil?
      MERCHANTS_WITH_CUSTOM_STORE_SLUGS.member? store_slug
    end

    def user_owns_store?(store_id)
      !current_user.nil? && current_user.store_ids.include?(store_id)
    end

    def set_gon
      gon.page = "#{params[:controller]}_#{params[:action]}"
      gon.pagination_page = params[:page] || 1
      gon.authenticated = user_signed_in?
      gon.layout = params[:layout]
      gon.debug = DEBUG
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
      mobile_device? && !(request.user_agent =~ /iPhone|iPad|iPod/).nil?
    end

    def mobile_device?
      request.user_agent =~ /Mobile|webOS/
    end

    def browser_is_instagram?
      (DEBUG && params[:acts_as_instagram_browser] == 'true') ||
        !(request.user_agent =~ /Instagram/).nil?
    end

    def show_view_more_products_button?(max_pagination_page)
      max_pagination_page > 1
    end

    def products_json(products)
      Jbuilder.encode do |json|
        json.products(products) do |json, product|
          json.product_name product.name
          json.product_price number_to_currency(product.price)
          json.product_slug product.slug
          json.product_status product.status
          json.product_instagram_tag product.get_instagram_tag

          json.store_name product.store.name
          json.store_slug product.store.slug

          json.custom_merchant_wrapper_class view_context.custom_merchant_css_class_for_product(product.store.slug)
          json.user_owns_store user_owns_store?(product.store.id)
        end
      end
    end
end
