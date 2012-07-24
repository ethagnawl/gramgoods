class RegistrationsController < Devise::RegistrationsController
  def create
    super
    #@user.update_attributes({
    #  :name => session[:omniauth][:info][:name],
    #  :website => session[:omniauth][:info][:website],
    #  :thumbnail => session[:omniauth][:info][:thumbnail]
    #})
    #session[:omniauth] = nil
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
