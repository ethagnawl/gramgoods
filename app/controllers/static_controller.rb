class StaticController < ApplicationController
  layout 'mobile'

  def tos
    render 'tos'
  end

  def desktop_welcome
    render 'desktop_welcome', :layout => false
  end
end
