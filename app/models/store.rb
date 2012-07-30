class Store < ActiveRecord::Base
  belongs_to :user
  has_many :products
  extend FriendlyId

  friendly_id :url, :use => [:slugged, :history]

  attr_accessible :name, :url, :user_id, :return_policy
  validates_presence_of :name, :url, :return_policy
  validates_uniqueness_of :url, :name

  validate :url_has_changed, :on => :update

  private

  def url_has_changed
    if self.url_changed? && self.url != self.url_was
      errors[:base] = 'You cannot change your store\'s URL.'
    end
  end
end
