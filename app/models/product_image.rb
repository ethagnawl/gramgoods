class ProductImage < ActiveRecord::Base
  belongs_to :product

  attr_accessible :instagram_id, :url, :tags

  validates_presence_of :instagram_id, :url

  def self.product_image_ids(product)
    #  what is self?
    p = Product.find(product)
    p.product_images.map { |product_image| product_image.instagram_id }
  end
end
