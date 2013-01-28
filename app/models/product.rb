class Product < ActiveRecord::Base
  FLATRATE_SHIPPING_OPTIONS = %w{ domestic international }

  include ActionView::Helpers::NumberHelper

  belongs_to :store
  has_many :colors, :dependent => :destroy, :before_add => :set_nest
  has_many :sizes, :dependent => :destroy, :before_add => :set_nest
  extend FriendlyId

  scope :recent_active_products, Proc.new { |limit|
    limit ||= 10
    where(:status => 'Active').
      limit(limit).
      order('updated_at DESC').
      includes([:store])
  }

  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :price, :quantity, :description, :store_id, :status,
  :domestic_flatrate_shipping_cost, :international_flatrate_shipping_cost,
  :unlimited_quantity, :colors_attributes,
  :sizes_attributes, :colors, :sizes, :product_images, :purchase_type

  validates_presence_of :name, :price, :description, :product_images, :purchase_type
  validates :quantity, :presence => true,
    :unless => Proc.new { |product| product.unlimited_quantity == true }
  validates_numericality_of :price, :greater_than => 0.00
  validates_numericality_of :domestic_flatrate_shipping_cost, :greater_than => 0.00,
    :unless => Proc.new { |product| product.domestic_flatrate_shipping_cost.nil? }
 validates_numericality_of :international_flatrate_shipping_cost, :greater_than => 0.00,
    :unless => Proc.new { |product| product.international_flatrate_shipping_cost.nil? }

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
    if self.product_images.nil?
      []
    else
      self.product_images.split(',')
    end
  end

  def normalize_quantity
    self.quantity = 0 if self.quantity.nil? or self.unlimited_quantity == true
  end

  def is_purchasable?
    if self.quantity.nil?
      self.unlimited_quantity == true && self.status == 'Active'
    else
      (self.quantity > 0 || self.unlimited_quantity == true) && self.status == 'Active'
    end
  end

  def belongs_to_customized_store?
    self.store.is_slug_in_merchants_with_custom_store_slugs_array?
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

  def self.flatrate_shipping_options
    FLATRATE_SHIPPING_OPTIONS
  end

  def flatrate_shipping_options
    Product.flatrate_shipping_options.find_all do |flatrate_shipping_option|
      self.send("#{flatrate_shipping_option}_flatrate_shipping_cost")
    end
  end

  def valid_flatrate_shipping_option?(flatrate_shipping_option)
    flatrate_shipping_options.member? flatrate_shipping_option
  end

  def flatrate_shipping_option_costs
    flatrate_shipping_options.map do |flatrate_shipping_option|
      self.send("#{flatrate_shipping_option}_flatrate_shipping_cost")
    end
  end

  def flatrate_shipping_option_cost(flatrate_shipping_option)
    if valid_flatrate_shipping_option?(flatrate_shipping_option)
      self.send("#{flatrate_shipping_option}_flatrate_shipping_cost")
    else
      nil
    end
  end

  # TODO: rename this valid_shipping_option_cost?
  def valid_shipping_cost?(cost)
    flatrate_shipping_option_costs.member? cost
  end

  # allow nested attributes to use x.product before product has been saved
  # http://stackoverflow.com/questions/2611459
  def set_nest(item)
    item.product ||= self
  end
end
