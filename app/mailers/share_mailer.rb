class ShareMailer < ActionMailer::Base
  default :from => "admin@gramgoods.com",
          :reply_to => 'admin@gramgoods.com'

  def share_text(user_email, product)
    @product = product
    mail( :to => user_email,
          :subject => "GramGoods - Product Share Text")
  end
end
