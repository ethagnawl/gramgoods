class ShareMailer < ActionMailer::Base
  default :from => "admin@gramgoods.com",
          :reply_to => 'admin@gramgoods.com'

  def share_text(user_email, product, store_slug, user_instagram)
    @product = product
    @store_slug = store_slug
    @user_instagram = user_instagram
    mail( :to => user_email,
          :subject => "GramGoods - Product Share Text")
  end
end
