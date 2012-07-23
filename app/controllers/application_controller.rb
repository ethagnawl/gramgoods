class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :clear_gon
  before_filter :set_gon
  before_filter :basic_authentication

  def after_sign_in_path_for(resource)
    stores_path
  end

  private

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
