class Store < ActiveRecord::Base
  belongs_to :user
  has_many :products, :order => 'updated_at DESC', :dependent => :destroy
  has_many :orders, :order => 'updated_at DESC'
  extend FriendlyId

  friendly_id :name, :use => [:slugged, :history]

  after_create :deliver_store_confirmation

  attr_accessible :name, :return_policy, :terms_of_service
  validates_presence_of :name, :return_policy
  validates_uniqueness_of :name
  validates_acceptance_of :terms_of_service, :on => :create

  def displayable_products(limit = nil)
    # external products are set to Active by default, so this will
    # work, but it really should become a proper AR || SQL query
    self.products.
      where(:status => ['Active', 'Out of Stock']).
      limit(limit).
      includes([:store])
  end

  def is_slug_in_merchants_with_custom_store_slugs_array?
    return false if !defined?(MERCHANTS_WITH_CUSTOM_STORE_SLUGS) || MERCHANTS_WITH_CUSTOM_STORE_SLUGS.nil?
    MERCHANTS_WITH_CUSTOM_STORE_SLUGS.member? self.slug
  end

  private
    def deliver_store_confirmation
      StoreMailer.delay.store_confirmation(self, owner)
    end

    def owner
      self.user
    end
end
