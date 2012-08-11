class Order < ActiveRecord::Base
  belongs_to :store
  has_many :line_items, :order => 'updated_at DESC'
  has_one :recipient

  attr_accessible :line_items_attributes, :recipient_attributes

  accepts_nested_attributes_for :line_items, :recipient
end
