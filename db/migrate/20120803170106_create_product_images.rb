class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.timestamps
      t.integer 'product_id'
    end

    add_index "product_images", ["product_id"], :name => "index_product_imagess_on_product_id"
  end
end
