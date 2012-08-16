class Order < ActiveRecord::Base
  belongs_to :store
  has_one :line_item, :order => 'updated_at DESC'
  has_one :recipient

  attr_accessible :line_item_attributes, :recipient_attributes, :status

  accepts_nested_attributes_for :line_item, :recipient
  validates_associated :line_item
end
