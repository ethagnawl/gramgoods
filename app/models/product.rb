class Product < ActiveRecord::Base
  belongs_to :store
  has_many :product_images
  has_one :instagram_tag
  has_many :colors
  has_many :sizes
  extend FriendlyId

  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :price, :quantity, :description, :store_id, :status,
  :flatrate_shipping_cost, :unlimited_quantity, :product_images_attributes,
  :instagram_tag_attributes, :colors_attributes, :sizes_attributes, :instagram_tag,
  :colors, :sizes

  validates_presence_of :name, :price, :description
  validates :quantity, :presence => true,
    :unless => Proc.new { |product| product.unlimited_quantity == true }
  validates_numericality_of :price, :greater_than => 0.00
  validates_numericality_of :flatrate_shipping_cost, :greater_than => 0.00,
    :unless => Proc.new { |product| product.flatrate_shipping_cost.nil? }
  validate :require_instagram_tag

  accepts_nested_attributes_for :product_images, :instagram_tag, :colors, :sizes

  before_save :normalize_quantity
  after_save :deliver_share_text

  def self.order_status_array
    ['Draft', 'Active', 'Out of Stock']
  end

  def deliver_share_text
    ShareMailer.share_text(self.store.user.email, self).deliver
  end

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
    update_column(:status, status)
  end

  def deduct_from_quantity(quantity)
    unless self.unlimited_quantity == true
      update_column(:quantity, (self.quantity -= quantity))

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

  def get_instagram_tag
    self.instagram_tag.instagram_tag
  end

  def get_colors
    self.colors.map { |color| color.color }.join(', ')
  end

  def get_sizes
    self.sizes.map { |size| size.size }.join(', ')
  end

  def like_count
    product_images_with_likes = self.product_images.reject do |product_image|
      !product_image.likes.is_a? Integer
    end
    product_images_with_likes.inject(0) {|sum, product_image| sum + product_image.likes }
  end

  def require_instagram_tag
    if instagram_tag.nil?
      errors.add(:base, 'You must provide at least one Instagram tag.')
    end
  end
end
