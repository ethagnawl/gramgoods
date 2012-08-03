class AddingColumnsToProductImages < ActiveRecord::Migration
  def up
    add_column :product_images, :instagram_id, :string
    add_column :product_images, :url, :string
    add_column :product_images, :tags, :string
  end

  def down
    remove_column :product_images, :instagram_id, :string
    remove_column :product_images, :url, :string
    remove_column :product_images, :tags, :string
  end
end
