class StaticController < ApplicationController
  layout 'mobile'

  def tos
    render 'tos'
  end

  def desktop_welcome
    if user_signed_in?
      redirect_to root_path
    else
      render 'desktop_welcome', :layout => false
    end
  end
end
