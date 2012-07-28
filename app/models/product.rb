class Product < ActiveRecord::Base
  belongs_to :store
  extend FriendlyId

  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :price, :quantity, :description, :store_id, :status,
  :colors, :sizes, :flatrate_shipping_cost, :instagram_tag, :photos,
  :unlimited_quantity
  validates_presence_of :name, :price, :description, :instagram_tag
  validates :quantity, :presence => true,
    :unless => Proc.new { |product| product.unlimited_quantity == true }

  def photos_array
    return [] if self.photos.nil? || self.photos.empty?
    return [self.photos] unless self.photos.include?(',')
    self.photos.split(',')
  end

  def get_quantity
    self.unlimited_quantity == true ? 'Unlimited Quantity' : self.quantity
  end
end
