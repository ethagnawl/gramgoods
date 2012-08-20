class AddingPrecisionAndScaleToProductFlatrateShippingCost < ActiveRecord::Migration
  def change
    change_column :products, :flatrate_shipping_cost, :decimal, :precision => 10, :scale => 2
  end
end
