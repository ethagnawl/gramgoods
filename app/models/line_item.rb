class LineItem < ActiveRecord::Base
  belongs_to :order

  attr_accessible :quantity, :size, :color, :size, :price, :total
  validates_presence_of :quantity, :size, :color, :size, :price, :total
end
