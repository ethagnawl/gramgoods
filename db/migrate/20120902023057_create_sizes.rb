class CreateSizes < ActiveRecord::Migration
  def change
    create_table :sizes do |t|

      t.timestamps
      t.integer 'product_id'
      t.string 'size'
    end

    add_index "sizes", ["product_id"], :name => "index_sizes_on_product_id"
  end
end
