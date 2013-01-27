class ChangeLineItemsFlatrateShippingCostToFlatrateShippingOptionCost < ActiveRecord::Migration
  def change
    rename_column :line_items, :flatrate_shipping_cost, :flatrate_shipping_option_cost
  end
end
