class Product < ActiveRecord::Base
  belongs_to :store, :dependent => :destroy

  attr_accessible :name, :price, :quantity, :description
  validates_presence_of :name, :price, :quantity, :description
end
