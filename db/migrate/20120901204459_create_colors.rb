class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|

      t.timestamps
      t.integer 'product_id'
    end

    add_index "colors", ["product_id"], :name => "index_colors_on_product_id"
  end
end
