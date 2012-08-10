class AddColumnsToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :product_id, :integer
    add_column :line_items, :quantity, :integer
    add_column :line_items, :size, :string
    add_column :line_items, :color, :string
    add_column :line_items, :price, :decimal
    add_column :line_items, :total, :decimal
  end
end
