class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def instagram
    #raise request.env['omniauth.auth'].to_yaml
    user_params = request.env['omniauth.params']['user'] ||= nil
    store_params = request.env['omniauth.params']['store'] ||= nil
    user = User.from_omniauth(request.env['omniauth.auth'], user_params, store_params)
    if !user
      flash[:alert] = 'Please create an account before signing in.'
      redirect_to products_path
    elsif user.persisted?
      flash[:notice] = "Signed in successfully as #{user.username}."
      sign_in_and_redirect(user)
    else
      session['devise.user_attributes'] = user.attributes
      redirect_to new_user_registration_url
    end
  end
end
