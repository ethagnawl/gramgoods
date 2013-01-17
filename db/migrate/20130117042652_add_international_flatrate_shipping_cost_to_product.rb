class AddInternationalFlatrateShippingCostToProduct < ActiveRecord::Migration
  def change
    add_column :products, :international_flatrate_shipping_cost, :decimal
  end
end
