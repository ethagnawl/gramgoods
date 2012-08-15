class LineItem < ActiveRecord::Base
  belongs_to :order

  attr_accessible :quantity, :color, :size, :price, :total, :flatrate_shipping_cost,
    :product_id
  validates_presence_of :quantity, :price, :total, :product_id
end
