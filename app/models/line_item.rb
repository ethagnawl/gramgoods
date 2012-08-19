class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  attr_accessible :quantity, :color, :size, :price, :total, :flatrate_shipping_cost,
    :product_id
  validates_presence_of :quantity, :price, :total, :product_id

  validate :line_item_quantity_must_be_less_than_or_equal_to_product_quantity
  validate :line_item_order_product_status_must_be_active

  def line_item_quantity_must_be_less_than_or_equal_to_product_quantity
    product = Product.find(product_id)
    unless product.quantity.nil?
      if quantity > product.quantity && product.unlimited_quantity == false
        errors.add(:quantity, 'must be less than or equal to product quantity')
      end
    else
      # this should *never* happen, but just in case
      if product.unlimited_quantity == false
        errors.add(:quantity, 'must be less than or equal to product quantity')
      end
    end
  end

  def line_item_order_product_status_must_be_active
    product = Product.find(product_id)
    if product.status != 'Active'
      errors[:base] << 'You cannot purchase a product whose status is not active.'
    end
  end
end
