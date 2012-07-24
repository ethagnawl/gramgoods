class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication && authentication.user.present?
      flash[:notice] = 'Signed in successfully.'
      sign_in_and_redirect(:user, authentication.user)
    else
      flash[:alert] = 'Something went wrong, please try again.'
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to(authentications_url)
  end
end
