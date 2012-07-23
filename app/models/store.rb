class Store < ActiveRecord::Base
  belongs_to :user
  has_many :products
  extend FriendlyId

  friendly_id :url, :use => [:slugged, :history]

  attr_accessible :name, :url, :user_id, :return_policy
  validates_presence_of :name, :url, :return_policy
  validates_uniqueness_of :url
end
