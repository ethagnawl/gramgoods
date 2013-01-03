class ChangingProductImagesToText < ActiveRecord::Migration
  def change
    change_column :products, :product_images, :text
  end
end
