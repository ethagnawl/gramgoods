class StaticController < ApplicationController
  layout 'mobile'

  def tos
    render 'tos'
  end

  def use_mobile_safari
    render 'use_mobile_safari'
  end
end
