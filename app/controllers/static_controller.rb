class StaticController < ApplicationController
  layout 'mobile'

  def tos
    render 'tos'
  end

  def use_mobile_safari
    if browser_is_instagram?
      render 'use_mobile_safari'
    else
      redirect_to root_path
    end
  end
end
