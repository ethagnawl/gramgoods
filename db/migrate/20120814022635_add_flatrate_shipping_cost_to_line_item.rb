class AddFlatrateShippingCostToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :flatrate_shipping_cost, :decimal
  end
end
