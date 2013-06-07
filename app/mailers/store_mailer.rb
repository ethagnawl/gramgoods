class StoreMailer < ActionMailer::Base
  default :from => ADMIN_EMAIL_ADDRESS,
          :reply_to => ADMIN_EMAIL_ADDRESS

  def store_confirmation(store, owner)
    pry
    @store = store

    mail( :to => owner.email_address,
          :subject => "Welcome to GramGoods!")
  end
end
