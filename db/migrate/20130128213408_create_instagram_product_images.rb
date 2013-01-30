class CreateInstagramProductImages < ActiveRecord::Migration
  def change
    create_table :instagram_product_images do |t|
      t.integer :product_id

      t.timestamps
    end
  end
end
