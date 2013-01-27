class LineItem < ActiveRecord::Base
  belongs_to :order

  # freezes product attributes in case product name, price, etc. changes
  attr_accessible :quantity, :color, :size, :price, :total,
    :flatrate_shipping_option, :flatrate_shipping_option_cost,
    :product_id, :product_name
  validates_presence_of :quantity, :price, :total, :product_id, :product_name

  validate :line_item_quantity_must_be_less_than_or_equal_to_product_quantity
  validate :line_item_order_product_status_must_be_active
  validate :product_attributes

  def product_attributes
    product = Product.find(self.product_id)

    unless product.flatrate_shipping_options.empty?
      if !self.flatrate_shipping_option_cost || !product.valid_shipping_cost?(self.flatrate_shipping_option_cost)
        errors.add(:flatrate_shipping_option_cost, 'must be valid.')
      end
    end

    if product.name != self.product_name
      errors.add(:product_name, 'must be valid.')
    end
    if product.price != self.price
      errors.add(:price, 'must be valid.')
    end
    if product.id != self.product_id
      errors.add(:product_id, 'must be valid.')
    end
  end

  def line_item_quantity_must_be_less_than_or_equal_to_product_quantity
    product = Product.find(self.product_id)
    unless product.quantity.nil?
      if self.quantity > product.quantity && product.unlimited_quantity == false
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
    product = Product.find(self.product_id)
    unless product.status == 'Active'
      errors.add(:quantity, 'You cannot purchase a product whose status is not active.')
    end
  end
end
