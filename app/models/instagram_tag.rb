class InstagramTag < ActiveRecord::Base
  belongs_to :product
  attr_accessible :instagram_tag
  validates_presence_of :instagram_tag
  before_save :strip_leading_hash_from_instagram_tag

  private

    def strip_leading_hash_from_instagram_tag
      self.instagram_tag.gsub!(/^#+/, '')
    end
end
