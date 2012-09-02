class Size < ActiveRecord::Base
  belongs_to :product
  attr_accessible :size
  validates_presence_of :size
end
