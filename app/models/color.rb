class Color < ActiveRecord::Base
  belongs_to :product
  attr_accessible :color
end
