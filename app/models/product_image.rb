class ProductImage < ActiveRecord::Base
  belongs_to :product

  attr_accessible :instagram_id, :url, :tags

  validates_presence_of :instagram_id, :url
end
