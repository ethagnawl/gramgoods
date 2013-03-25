class Product < ActiveRecord::Base
  FLATRATE_SHIPPING_OPTIONS = %w{ domestic international }

  include ActionView::Helpers::NumberHelper

  belongs_to :store
  has_many :colors, :dependent => :destroy, :before_add => :set_nest
  has_many :sizes, :dependent => :destroy, :before_add => :set_nest
  has_many :user_product_images, dependent: :destroy
  has_many :instagram_product_images, dependent: :destroy
  extend FriendlyId

  scope :recent_active_products, Proc.new { |limit|
    limit ||= 10
    p = Product.arel_table

    where(p[:status].eq('Active').or(p[:external].eq(true))).
      limit(limit).
      order('updated_at DESC').
      includes([:store, :user_product_images, :instagram_product_images])
  }

  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :price, :quantity, :description, :store_id, :status,
  :domestic_flatrate_shipping_cost, :international_flatrate_shipping_cost,
  :unlimited_quantity, :colors_attributes, :sizes_attributes, :colors, :sizes,
  :user_product_images, :user_product_images_attributes, :instagram_product_images,
  :instagram_product_images_attributes, :purchase_type, :external, :external_url

  validates_presence_of :name, :price
  validates_presence_of :description, :unless => Proc.new { |product| product.external == true }
  validates_presence_of :external_url, :if => Proc.new { |product| product.external == true }
  validates :quantity, :presence => true,
    :unless => Proc.new { |product| product.unlimited_quantity == true || product.external == true }
  validates_numericality_of :price, :greater_than => 0.00, :unless => Proc.new { |product| product.external == true }
  validates_numericality_of :domestic_flatrate_shipping_cost, :greater_than => 0.00,
    :unless => Proc.new { |product| product.domestic_flatrate_shipping_cost.nil? || product.external == true }
  validates_numericality_of :international_flatrate_shipping_cost, :greater_than => 0.00,
    :unless => Proc.new { |product| product.international_flatrate_shipping_cost.nil? || product.external == true }
  validate :has_at_least_one_product_photo

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
  before_save :normalize_external_url

  def self.order_status_array
    ['Draft', 'Active', 'Out of Stock']
  end

  def store_slug
    self.store.slug
  end

  def get_user_product_images
    self.user_product_images.map{ |image| strip_protocol(image.image.url(:large)) }
  end

  def get_instagram_product_images
    self.instagram_product_images.map{ |image| strip_protocol(image.url) }
  end

  def get_product_images
    self.get_user_product_images + self.get_instagram_product_images
  end

  def normalize_quantity
    unless self.external?
      self.quantity = 0 if self.quantity.nil? or self.unlimited_quantity == true
    end
  end

  def normalize_external_url
    if self.external == true
      if (/^http(s)?:\/\// =~ self.external_url).nil?
        self.external_url = "http://#{self.external_url}"
      end
    end
  end

  def is_purchasable?
    if self.external?
      true
    elsif self.quantity.nil?
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

  def increment_external_clickthroughs
    if self.external?
      update_column(:external_clickthroughs, self.external_clickthroughs += 1)
    end
  end

  # allow nested attributes to use x.product before product has been saved
  # http://stackoverflow.com/questions/2611459
  def set_nest(item)
    item.product ||= self
  end

  private
    def strip_protocol(url)
      if url =~ /(https?:)/
        url.split($1)[1]
      else
        url
      end
    end

    def has_at_least_one_product_photo
      if (user_product_images.empty? or user_product_images.all? {|child| child.marked_for_destruction? }) && (instagram_product_images.empty? or instagram_product_images.all? {|child| child.marked_for_destruction? })
        errors.add(:base, 'You must upload or attach at least one product photo.')
      end
    end
end
