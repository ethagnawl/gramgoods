class InstagramTag < ActiveRecord::Base
  belongs_to :product
  attr_accessible :instagram_tag
  validates_presence_of :instagram_tag
end
