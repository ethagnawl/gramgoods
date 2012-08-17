class OrderMailer < ActionMailer::Base
  default :from => "admin@gramgoods.com",
          :to => order.recipient.email_address,
          :cc => [order.store.user.email, 'admin@gramgoods.com'],
          :reply_to => 'admin@gramgoods.com'

  def order_confirmation(order, product)
    @order = order
    @product = product
    mail(:subject => "GramGoods Order Confirmation - Order ##{order.id}")
  end
end
