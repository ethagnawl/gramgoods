class RemoveProductImagesFromProduct < ActiveRecord::Migration
  def change
    remove_column :products, :product_images
  end
end
