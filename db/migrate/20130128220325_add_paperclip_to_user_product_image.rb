class AddPaperclipToUserProductImage < ActiveRecord::Migration
  def change
    add_column :user_product_images, :image_file_name, :string
    add_column :user_product_images, :image_content_type, :string
    add_column :user_product_images, :image_file_size, :integer
  end
end
