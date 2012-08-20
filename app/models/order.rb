class Order < ActiveRecord::Base
  belongs_to :store
  has_one :line_item, :order => 'updated_at DESC'
  has_one :recipient

  attr_accessible :line_item_attributes, :recipient_attributes, :status

  accepts_nested_attributes_for :line_item, :recipient
  validates_associated :line_item

  def charge(stripe_total, token)
    charge = Stripe::Charge.create(
      :amount => stripe_total,
      :currency => "usd",
      :card => token,
      :description => "GramGoods Order ##{self.id}"
    )
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while processing transaction: #{e.message}"
    errors.add :base, "There was a problem processing your transaction, please try again. If the problem persists, contact admin@gramgoods.com"
    false
  end
end
