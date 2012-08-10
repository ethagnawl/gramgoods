class Product < ActiveRecord::Base
  belongs_to :store
  has_many :product_images
  extend FriendlyId

  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :price, :quantity, :description, :store_id, :status,
  :colors, :sizes, :flatrate_shipping_cost, :instagram_tag, :photos,
  :unlimited_quantity, :product_images_attributes
  validates_presence_of :name, :price, :description, :instagram_tag
  validates :quantity, :presence => true,
    :unless => Proc.new { |product| product.unlimited_quantity == true }

  accepts_nested_attributes_for :product_images

  def photos_array
    self.product_images.map { |product_image| product_image.url }.reject { |product_image| product_image.empty? }
  end

  def thumbnails_array
    self.product_images.map { |product_image| product_image.thumbnail }.reject { |product_image| product_image.empty? }
  end

  def first_product_image
    if self.product_images.length > 0
      self.product_images.first.url
    else
      ''
    end
  end

  def product_image_ids
    self.product_images.map { |product_image| product_image.instagram_id }
  end

  def product_image_urls
    self.product_images.map { |product_image| product_image.url }
  end

  def get_quantity
    self.unlimited_quantity == true ? 'Unlimited Quantity' : self.quantity
  end

  def get_instagram_tags
    self.instagram_tag.split(',')
  end
end
