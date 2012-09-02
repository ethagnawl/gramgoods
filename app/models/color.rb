class Color < ActiveRecord::Base
  belongs_to :product
  attr_accessible :color
  validates_presence_of :color
end
