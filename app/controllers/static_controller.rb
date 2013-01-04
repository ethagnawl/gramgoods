class StaticController < ApplicationController
  layout 'mobile'

  def tos
    render 'tos'
  end
end
