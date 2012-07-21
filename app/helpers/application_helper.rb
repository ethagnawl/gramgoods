module ApplicationHelper

  #- configure_instagram(@user.authentications.first.uid, @user.authentications.first.access_token)
  #= Instagram.user_recent_media(@user.authentications.first.uid)
  #- Instagram.reset

  def configure_instagram(client_key, access_token)
    Instagram.configure do |config|
      config.client_id = client_key
      config.access_token = access_token
    end
  end
end
