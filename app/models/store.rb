class Store < ActiveRecord::Base
  belongs_to :user
  has_many :products, :order => 'updated_at DESC'
  extend FriendlyId

  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :user_id, :return_policy
  validates_presence_of :name, :return_policy
  validates_uniqueness_of :name

  def displayable_products
    self.products.reject { |product| product.status == 'Draft' }
  end
end
