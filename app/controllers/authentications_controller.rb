class AuthenticationsController < ApplicationController
  def index
    @authentication = current_user.authentication if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    if current_user
      current_user.create_authentication!(
        :thumbnail => omniauth['info']['image'],
        :nickname => omniauth['info']['nickname'],
        :provider => omniauth['provider'],
        :uid => omniauth['uid'],
        :access_token => omniauth['credentials']['token'])
      flash[:notice] = "Authentication successful."
      redirect_to(stores_path)
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  def destroy
    current_user.authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to(stores_path)
  end
end

