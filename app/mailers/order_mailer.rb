class OrderMailer < ActionMailer::Base
  default :from => "admin@gramgoods.com"

  def order_confirmation(order, product)
    @order = order
    @product = product
    mail(:to => order.recipient.email_address, :subject => 'GramGoods Order NNN')
  end
end
