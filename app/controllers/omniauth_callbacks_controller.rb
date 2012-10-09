class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def instagram
    #raise request.env['omniauth.auth'].to_yaml
    user_params = request.env['omniauth.params']['user']
    store_params = request.env['omniauth.params']['store']
    user = User.from_omniauth(request.env['omniauth.auth'], user_params, store_params)
    if user.persisted?
      flash[:notice] = "Signed in successfully as #{user.username}."
      sign_in_and_redirect(user)
    else
      session['devise.user_attributes'] = user.attributes
      redirect_to new_user_registration_url
    end
  end
end
