class Store < ActiveRecord::Base
  belongs_to :user
  has_many :products

  attr_accessible :name, :url
  validates_presence_of :name, :url
end
