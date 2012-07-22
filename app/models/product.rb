class Product < ActiveRecord::Base
  belongs_to :store

  attr_accessible :name, :price, :quantity, :description, :store_id, :status,
  :colors, :sizes, :flatrate_shipping_cost, :instagram_tag, :photos
  validates_presence_of :name, :price, :quantity, :description, :instagram_tag

  def photos_array
    return [] if self.photos.nil?
    return [self.photos] unless self.photos.include?(',')
    self.photos.split(',')
  end
end
