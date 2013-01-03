class Product < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :store
  has_one :instagram_tag, :dependent => :destroy
  has_many :colors, :dependent => :destroy, :before_add => :set_nest
  has_many :sizes, :dependent => :destroy, :before_add => :set_nest
  extend FriendlyId

  scope :recent_active_products, Proc.new { |limit|
    limit ||= 10
    where(:status => 'Active').
      limit(limit).
      order('updated_at DESC').
      includes([:store, :instagram_tag])
  }

  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :price, :quantity, :description, :store_id, :status,
  :flatrate_shipping_cost, :unlimited_quantity,
  :instagram_tag_attributes, :colors_attributes, :sizes_attributes, :instagram_tag,
  :colors, :sizes, :product_images

  validates_presence_of :name, :price, :description
  validates :quantity, :presence => true,
    :unless => Proc.new { |product| product.unlimited_quantity == true }
  validates_numericality_of :price, :greater_than => 0.00
  validates_numericality_of :flatrate_shipping_cost, :greater_than => 0.00,
    :unless => Proc.new { |product| product.flatrate_shipping_cost.nil? }
  validate :require_instagram_tag

  accepts_nested_attributes_for :instagram_tag
  accepts_nested_attributes_for :colors,
    :reject_if => lambda { |attrs|
      attrs.all? { |key, value| value.blank? }
    },
    :allow_destroy => true

  accepts_nested_attributes_for :sizes,
    :reject_if => lambda { |attrs|
      attrs.all? { |key, value| puts value; value.blank? }
    },
    :allow_destroy => true


  before_save :normalize_quantity

  def self.order_status_array
    ['Draft', 'Active', 'Out of Stock']
  end

  def get_product_images
    self.product_images.split(',')
  end

  def normalize_quantity
    self.quantity = 0 if self.quantity.nil? or self.unlimited_quantity == true
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

  def get_quantity
    self.unlimited_quantity == true ? 'Unlimited Quantity' : self.quantity
  end

  def get_instagram_tag(with_hash = false)
    instagram_tag = self.instagram_tag.instagram_tag
    instagram_tag = '#' << instagram_tag if with_hash == true
    instagram_tag
  end

  def get_colors
    self.colors.map { |color| color.color }.join(', ')
  end

  def get_sizes
    self.sizes.map { |size| size.size }.join(', ')
  end

  def get_instagram_caption
    caption = "http://www.gramgoods.com/#{self.store.slug}/#{self.slug}"
    caption << " Buy #{self.name} for #{number_to_currency(self.price)} by"
    caption << " visiting @#{self.store.user.username} and clicking the link in our profile."
    caption << " Sizes: #{self.get_sizes}" unless self.get_sizes.empty?
    caption << " Colors: #{self.get_colors}" unless self.get_colors.empty?
    caption << " #{self.get_instagram_tag(true)}"
  end

  def require_instagram_tag
    if instagram_tag.nil?
      errors.add(:base, 'You must provide at least one Instagram tag.')
    end
  end

  # allow nested attributes to use x.product before product has been saved
  # http://stackoverflow.com/questions/2611459
  def set_nest(item)
    item.product ||= self
  end
end
