class StaticController < ApplicationController
  def tos
    render 'static/tos', :layout => 'mobile'
  end
end
