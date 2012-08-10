class AddProductIdIndexToLineItems < ActiveRecord::Migration
  def change
    add_index :line_items, :product_id
  end
end
