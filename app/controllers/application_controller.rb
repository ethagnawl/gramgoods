class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :clear_gon
  before_filter :set_gon

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
end
