class AddProductImageStringToProduct < ActiveRecord::Migration
  def change
    add_column :products, :product_images, :string
  end
end
