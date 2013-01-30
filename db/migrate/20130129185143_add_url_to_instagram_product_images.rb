class AddUrlToInstagramProductImages < ActiveRecord::Migration
  def change
    add_column :instagram_product_images, :url, :string
  end
end
