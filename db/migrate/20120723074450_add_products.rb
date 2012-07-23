class AddProducts < ActiveRecord::Migration
  def up
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :status
      t.string :colors
      t.string :sizes
      t.string :instagram_tag
      t.string :photos
      t.decimal :price
      t.decimal :flatrate_shipping_cost
      t.integer :quantity
      t.integer :store_id
    end
  end

  def down
    drop_table :products
  end
end
