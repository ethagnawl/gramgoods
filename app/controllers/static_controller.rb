class StaticController < ApplicationController
  layout 'admin'
  def index
    # TODO move this into a before_filter in ApplicationController
    redirect_to(products_path) if mobile_device?
  end
end
