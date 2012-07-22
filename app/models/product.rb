class Product < ActiveRecord::Base
  belongs_to :store, :dependent => :destroy

  attr_accessible :name, :price, :quantity, :description, :store_id, :status,
  :colors, :sizes, :flatrate_shipping_cost, :instagram_tag
  validates_presence_of :name, :price, :quantity, :description, :instagram_tag
end
