class CreateUserProductImages < ActiveRecord::Migration
  def change
    create_table :user_product_images do |t|
      t.integer :product_id

      t.timestamps
    end
  end
end
