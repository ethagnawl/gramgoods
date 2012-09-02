class StaticController < ApplicationController
  layout 'static'

  def index
    # TODO move this into a before_filter in ApplicationController
    redirect_to(products_path) if mobile_device? && params[:layout] != 'desktop'
  end

  def tos
    render 'static/tos', :layout => 'admin'
  end
end
