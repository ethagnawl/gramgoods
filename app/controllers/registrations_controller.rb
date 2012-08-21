class RegistrationsController < Devise::RegistrationsController
  def create
    super
    #@user.update_attributes({
    ##  :name => session[:omniauth][:info][:name],
    ##  :website => session[:omniauth][:info][:website],
    #  :thumbnail => session[:omniauth][:info][:thumbnail]
    #})
    ##session[:omniauth] = nil
  end

  def edit
    @user = current_user
  end

  def update
    # this is such a hack...
    # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
    @user = User.find(current_user.id)
    if @user.update_without_password(params[:user])
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
