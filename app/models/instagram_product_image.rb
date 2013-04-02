class InstagramProductImage < ActiveRecord::Base
  attr_accessible :product_id, :url

  validates_presence_of :url

  def src
    self.url.split('http:')[1]
  end
end

