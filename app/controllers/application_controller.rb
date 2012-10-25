class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  protect_from_forgery
  before_filter :clear_gon
  before_filter :set_gon
  before_filter :ensure_proper_protocol
  before_filter :basic_authentication

  helper_method :mobile_device?
  helper_method :mobile_device_is_iOS?
  helper_method :user_owns_store?

  def after_sign_in_path_for(resource)
    unless current_user.first_store.nil?
      store = current_user.first_store

      if current_user.is_a_new_user?
        flash[:notice] = "#{store.name} has been created successfully. <br /> Be sure to add <a href='/#{store.slug}'>http://gramgoods.com/#{store.slug}</a> to your Instagram profile.".html_safe
        new_store_product_path(store)
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
    user_feed = fetch_instagram_feed_for_user_and_filter_by_tag(user, tag)
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

  private
    #TODO: move this into a module
    def fetch_instagram_feed_for_user_and_filter_by_tag(user, _tag)
      tag = _tag.downcase
      key = "#{user.uid}_#{tag}"
      user_photo_feed_from_cache = Rails.cache.read(key)

      if user_photo_feed_from_cache.nil?
        begin
          Instagram.configure do |config|
            config.client_id = user.uid
            config.access_token = user.access_token
          end
          media_count = (Instagram.user.counts.media).to_i
          last_id = nil
          i = 0
          max_id = nil
          user_photo_feed = []

          lambda { |r, max_id = nil|
            user_photo_feed.concat(
              Instagram.user_recent_media(:max_id => max_id).tap { |items|
                i += items.length
                last_id = items.last.id
              }.find_all { |item|
                item.tags.member? tag
              }.map { |item|
                {
                  :like_count => item.likes[:count],
                  :url => item.images.standard_resolution.url
                }
              })
            r.call(r, last_id) if i < media_count
          }.tap { |r| r.call(r) }

          Instagram.reset

          unless user_photo_feed.empty?
            Rails.cache.write key, user_photo_feed, :expires_in => 5.minutes
          end

          user_photo_feed

        rescue
          puts 'Instagram Connection Error'
        end
      else
        user_photo_feed_from_cache
      end
    end

    def user_owns_store?(store_id)
      !current_user.nil? && current_user.store_ids.include?(store_id)
    end

    def set_gon
      gon.page = "#{params[:controller]}_#{params[:action]}"
      gon.authenticated = user_signed_in?
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
      mobile_device? && !(request.user_agent =~ /iPhone|iPad|iPod/).nil?
    end

    def mobile_device?
      request.user_agent =~ /Mobile|webOS/
    end
end
