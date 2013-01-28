class UserProductImage < ActiveRecord::Base
  attr_accessible :product_id, :image, :image_file_name

  belongs_to :product

  has_attached_file :image, styles: {
    thumb: "100x100#",
    small: "300x300>",
    large: "600x600>"
  }
end
