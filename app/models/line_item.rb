class LineItem < ActiveRecord::Base
  belongs_to :order

  attr_accessible :quantity, :color, :size, :price, :total, :flatrate_shipping_cost
  validates_presence_of :quantity, :price, :total
end
