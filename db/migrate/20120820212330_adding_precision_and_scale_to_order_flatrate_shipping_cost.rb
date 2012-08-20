class AddingPrecisionAndScaleToOrderFlatrateShippingCost < ActiveRecord::Migration
  def change
    change_column :line_items, :price, :decimal, :precision => 10, :scale => 2
  end
end
