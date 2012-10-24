class StaticController < ApplicationController
  layout 'static'

  def tos
    render 'static/tos', :layout => 'admin'
  end
end
