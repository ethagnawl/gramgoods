class UserProductImage < ActiveRecord::Base
  attr_accessible :product_id, :image, :image_file_name

  belongs_to :product

  validate :ensure_image
  validate :file_dimensions
  validates_presence_of :image

  has_attached_file :image, styles: {
    large: "612x612"
  },
  convert_options: {
    large: '-background black -gravity center -extent 612x612'
  }

  def src
    self.image.url(:large)
  end

  private
    def error_message
      'Please verify that you are attempting to upload an image file.'
    end

    def ensure_image
      if (image_content_type =~ /^image.*/).nil?
        errors.add(:file, error_message)
      end
    end

    def file_dimensions
      begin
        dimensions = Paperclip::Geometry.from_file(image.queued_for_write[:original].path)
        if dimensions.width < 612 && dimensions.height < 612
          errors.add(:file,'Width or height must be at least 612px')
        end
      rescue
          errors.add(:file, error_message)
      end
    end
end
