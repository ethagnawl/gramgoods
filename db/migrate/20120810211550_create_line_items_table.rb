class CreateLineItemsTable < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.timestamps
      t.integer 'order_id'
    end

    add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  end
end
