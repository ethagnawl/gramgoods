class Order < ActiveRecord::Base
  belongs_to :store
  has_one :line_item, :order => 'updated_at DESC'
  has_one :recipient
  before_create :generate_access_key
  after_save :update_status, :update_product_quantity, :deliver_order_confirmation

  attr_accessible :line_item_attributes, :recipient_attributes, :status

  accepts_nested_attributes_for :line_item, :recipient
  validates_associated :line_item

  def save_with_payment(token)
    if valid?
      charge = Stripe::Charge.create(
        :amount => (self.line_item.total * 100).to_i,
        :currency => "usd",
        :card => token,
        :description => "GramGoods Order ##{self.id} - #{self.recipient.email_address}"
      )
      save!
    end
  rescue Exception => e
    logger.error "Stripe error while processing transaction: #{e.message}"
    false
  end

  def stripe_error_message
    "There was a problem processing your transaction, please try again. If the problem persists, contact #{ADMIN_EMAIL_ADDRESS}"
  end

  private

    def generate_access_key
      self.access_key = [id.to_s, SecureRandom.hex(10)].join
    end

    def update_status
      update_column(:status, 'success')
    end

    def update_product_quantity
      product = Product.find(self.line_item.product_id)
      product.deduct_from_quantity(self.line_item.quantity)
    end

    def deliver_order_confirmation
      OrderMailer.delay.order_confirmation(self)
    end
end
