module ApplicationHelper
  def configure_instagram(client_key, access_token)
    Instagram.configure do |config|
      config.client_id = client_key
      config.access_token = access_token
    end
  end

  def get_instagram_photo_feed_for_user(user)
    hoge = user.authentications.first
    configure_instagram(hoge.uid, hoge.access_token)
    user_photo_feed = Instagram.user_recent_media
    Instagram.reset
    user_photo_feed
  end

  def render_conditional_layout(layout = nil)
    if user_signed_in?
      render :layout => (layout.nil? ? 'admin' : layout)
    else
      render :layout => 'mobile'
    end
  end
end
