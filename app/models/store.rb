class Store < ActiveRecord::Base
  belongs_to :user
  has_many :products, :order => 'updated_at DESC', :dependent => :destroy
  has_many :orders, :order => 'updated_at DESC'
  extend FriendlyId

  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :return_policy, :terms_of_service
  validates_presence_of :name, :return_policy
  validates_uniqueness_of :name
  validates_acceptance_of :terms_of_service, :on => :create

  def displayable_products(limit = nil)
    self.products.
      where(:status => ['Active', 'Out of Stock']).
      limit(limit).
      includes([:store])
  end
end
