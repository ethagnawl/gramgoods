class UserProductImage < ActiveRecord::Base
  attr_accessible :product_id, :image, :image_file_name

  belongs_to :product

  validate :file_dimensions

  has_attached_file :image, styles: {
    large: "612x612"
  },
  convert_options: {
    large: '-background black -gravity center -extent 612x612'
  }

  validates_attachment_content_type :image, content_type: [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/jpg',
    'image/JPG'
  ]

  def src
    self.image.url(:large)
  end

  private
    def file_dimensions
      dimensions = Paperclip::Geometry.from_file(image.queued_for_write[:original].path)
      if dimensions.width < 612 && dimensions.height < 612
        errors.add(:file,'Width or height must be at least 612px')
      end
    end
end
