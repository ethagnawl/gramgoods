class Size < ActiveRecord::Base
  belongs_to :product
  attr_accessible :size
end
