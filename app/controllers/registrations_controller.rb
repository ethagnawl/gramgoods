class RegistrationsController < Devise::RegistrationsController
  force_ssl

  def create
    super
  end

  def edit
    @user = current_user
  end

  def update
    # this is such a hack...
    # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
    @user = User.find(current_user.id)
    email_changed = @user.email != params[:user][:email]
    password_changed = !params[:user][:password].empty?
    successfully_updated = if email_changed or password_changed
                             @user.update_with_password(params[:user])
                           else
                             params[:user].delete(:current_password)
                             @user.update_without_password(params[:user])
                           end

    if successfully_updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      flash[:notice] = 'Your account has been updated successfully.'
      redirect_to stores_path
    else
      render "edit"
    end
  end

  private

  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
end
