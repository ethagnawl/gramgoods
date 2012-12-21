class OrderMailer < ActionMailer::Base
  default :from => ADMIN_EMAIL_ADDRESS,
          :reply_to => ADMIN_EMAIL_ADDRESS

  def order_confirmation(order)
    @order = order

    mail( :to => order.recipient.email_address,
          :cc => [order.store.user.email, ADMIN_EMAIL_ADDRESS],
          :subject => "GramGoods Order Confirmation - Order ##{order.id}")
  end
end
