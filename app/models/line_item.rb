class LineItem < ActiveRecord::Base
  belongs_to :order

  attr_accessible :quantity, :color, :size, :price, :total, :flatrate_shipping_cost,
    :product_id
  validates_presence_of :quantity, :price, :total, :product_id

  validate :line_item_quantity_must_be_less_than_or_equal_to_product_quantity
  validate :line_item_order_product_status_must_be_active

  def line_item_quantity_must_be_less_than_or_equal_to_product_quantity
    unless self.product.quantity.nil?
      if self.quantity > self.product.quantity && self.product.unlimited_quantity == false
        errors.add(:quantity, 'must be less than or equal to product quantity')
      end
    else
      # this should *never* happen, but just in case
      if self.product.unlimited_quantity == false
        errors.add(:quantity, 'must be less than or equal to product quantity')
      end
    end
  end

  def line_item_order_product_status_must_be_active
    unless self.product.status == 'Active'
      errors.add(:quantity, 'You cannot purchase a product whose status is not active.')
    end
  end
end
