class InstagramTag < ActiveRecord::Base
  belongs_to :product
  attr_accessible :instagram_tag
  validates_presence_of :instagram_tag
  before_save :strip_leading_hashes
  before_save :replace_whitespace_with_underscores

  private

    def strip_leading_hashes
      self.instagram_tag.gsub!(/^#+/, '')
    end

    def replace_whitespace_with_underscores
      self.instagram_tag.gsub!(/\s+/, '_')
    end
end
