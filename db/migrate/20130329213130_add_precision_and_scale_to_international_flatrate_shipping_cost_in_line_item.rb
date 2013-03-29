class AddPrecisionAndScaleToInternationalFlatrateShippingCostInLineItem < ActiveRecord::Migration
  def change
    change_column :line_items, :international_flatrate_shipping_cost, :decimal, :precision => 10, :scale => 2
  end
end
