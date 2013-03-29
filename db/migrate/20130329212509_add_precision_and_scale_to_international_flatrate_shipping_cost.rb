class AddPrecisionAndScaleToInternationalFlatrateShippingCost < ActiveRecord::Migration
  def change
    change_column :products, :international_flatrate_shipping_cost, :decimal, :precision => 10, :scale => 2
  end
end
