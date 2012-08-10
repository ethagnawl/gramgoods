class AddThumbnailToProductImage < ActiveRecord::Migration
  def change
    add_column :product_images, :thumbnail, :string
  end
end
