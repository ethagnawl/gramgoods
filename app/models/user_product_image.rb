class UserProductImage < ActiveRecord::Base
  attr_accessible :product_id, :image, :image_file_name

  belongs_to :product

  validate :file_dimensions

  has_attached_file :image, styles: {
    medium: "300x300",
    large: "612x612"
  },
  convert_options: {
    medium: '-background black -gravity center -extent 300x300',
    large: '-background black -gravity center -extent 612x612'
  }

  private
    def file_dimensions
      dimensions = Paperclip::Geometry.from_file(image.queued_for_write[:original].path)
      if dimensions.width < 612 && dimensions.height < 612
        errors.add(:file,'Width or height must be at least 612px')
      end
    end
end
