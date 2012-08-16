class OrderMailer < ActionMailer::Base
  default :from => "admin@gramgoods.com"

  def order_confirmation(email_address)
    mail(:to => email_address, :subject => 'GramGoods Order NNN')
  end
end
