class Product < ActiveRecord::Base
  belongs_to :store
  has_many :product_images
  has_many :line_items
  extend FriendlyId

  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :price, :quantity, :description, :store_id, :status,
  :colors, :sizes, :flatrate_shipping_cost, :instagram_tag, :photos,
  :unlimited_quantity, :product_images_attributes
  validates_presence_of :name, :price, :description, :instagram_tag
  validates :quantity, :presence => true,
    :unless => Proc.new { |product| product.unlimited_quantity == true }

  accepts_nested_attributes_for :product_images

  before_save :normalize_quantity

  def normalize_quantity
    self.quantity = 0 if self.quantity.nil?
  end

  def is_orderable
    if self.quantity.nil?
      self.unlimited_quantity == true && self.status == 'Active'
    else
      (self.quantity > 0 || self.unlimited_quantity == true) && self.status == 'Active'
    end
  end

  def update_status(status)
    self.update_attributes :status => status
  end

  def deduct_from_quantity(quantity)
    unless self.unlimited_quantity == true
      self.update_attributes :quantity => (self.quantity -= quantity)

      # the quantity *should* never be less than 0
      # but just in case...
      update_status('Out of Stock') if self.quantity <= 0
    end
  end

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

  def like_count
    product_images_with_likes = self.product_images.reject do |product_image|
      !product_image.likes.is_a? Integer
    end
    product_images_with_likes.inject(0) {|sum, product_image| sum + product_image.likes }
  end
end
