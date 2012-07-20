class Store < ActiveRecord::Base
  belongs_to :user
  has_many :products

  attr_accessible :name, :url, :user_id
  validates_presence_of :name, :url
  validates_uniqueness_of :url
end
