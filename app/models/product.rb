class Product < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :store
  has_many :colors, :dependent => :destroy, :before_add => :set_nest
  has_many :sizes, :dependent => :destroy, :before_add => :set_nest
  has_many :user_product_images, dependent: :destroy
  has_many :instagram_product_images, dependent: :destroy
  extend FriendlyId

  scope :recent_active_products, Proc.new { |limit|
    limit ||= 10
    where(:status => 'Active').
      limit(limit).
      order('updated_at DESC').
      includes([:store, :user_product_images, :instagram_product_images])
  }

  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :price, :quantity, :description, :store_id, :status,
  :flatrate_shipping_cost, :unlimited_quantity, :colors_attributes,
  :sizes_attributes, :colors, :sizes, :user_product_images,
  :user_product_images_attributes, :instagram_product_images,
  :instagram_product_images_attributes

  validates_presence_of :name, :price, :description
  validates :quantity, :presence => true,
    :unless => Proc.new { |product| product.unlimited_quantity == true }
  validates_numericality_of :price, :greater_than => 0.00

  validates_presence_of :user_product_images, if: lambda { |product|
    product.instagram_product_images.empty?
  }

  validates_presence_of :instagram_product_images, if: lambda { |product|
    product.user_product_images.empty?
  }

  accepts_nested_attributes_for :user_product_images, allow_destroy: true
  accepts_nested_attributes_for :instagram_product_images, allow_destroy: true
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

  def product_images
    return []
  end

  def get_user_product_images
    self.user_product_images.map{ |image| image.image.url(:large) }
  end

  def get_instagram_product_images
    self.instagram_product_images.map{ |image| image.url }
  end

  def get_product_images
    self.get_user_product_images + self.get_instagram_product_images
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

  def get_colors
    self.colors.map { |color| color.color }.join(', ')
  end

  def get_sizes
    self.sizes.map { |size| size.size }.join(', ')
  end

  def status_class
    case self.status
      when 'Active' then 'btn-success'
      when 'Draft' then 'btn-warning'
      when 'Out of Stock' then 'btn-danger'
      else ''
    end
  end

  def flatrate_shipping_cost
  ''
  end

  # allow nested attributes to use x.product before product has been saved
  # http://stackoverflow.com/questions/2611459
  def set_nest(item)
    item.product ||= self
  end
end
