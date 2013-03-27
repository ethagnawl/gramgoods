class StaticController < ApplicationController
  layout 'mobile'

  def tos
    render 'tos'
  end

  def desktop_welcome
    if user_signed_in?
      redirect_to root_path
    else
      # homepage static assets contain absolute urls containing http://...
      if request.ssl?
        redirect_to :protocol => 'http://',
                    :controller => 'static',
                    :action => 'desktop_welcome'
      else
        render 'desktop_welcome', :layout => false
      end
    end
  end
end
