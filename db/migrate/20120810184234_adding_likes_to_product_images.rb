class AddingLikesToProductImages < ActiveRecord::Migration
  def change
    add_column :product_images, :likes, :integer
  end
end
