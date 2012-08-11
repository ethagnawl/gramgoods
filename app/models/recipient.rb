class Recipient < ActiveRecord::Base
  belongs_to :order
  attr_accessible :first_name, :last_name, :email_address, :street_address_one,
  :street_address_two, :city, :state, :postal_code
end
