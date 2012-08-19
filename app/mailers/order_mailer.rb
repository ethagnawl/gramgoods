class OrderMailer < ActionMailer::Base
  default :from => "admin@gramgoods.com",
          :reply_to => 'admin@gramgoods.com'

  def order_confirmation(order)
    @order = order

    mail( :to => order.recipient.email_address,
          :cc => [order.store.user.email, 'admin@gramgoods.com'],
          :subject => "GramGoods Order Confirmation - Order ##{order.id}")
  end
end
