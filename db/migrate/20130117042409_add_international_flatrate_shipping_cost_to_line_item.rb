class AddInternationalFlatrateShippingCostToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :international_flatrate_shipping_cost, :decimal
  end
end
