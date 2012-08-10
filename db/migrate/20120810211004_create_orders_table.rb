class CreateOrdersTable < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.timestamps
      t.integer 'store_id'
    end

    add_index "orders", ["store_id"], :name => "index_orders_on_store_id"
  end
end
