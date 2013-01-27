class AddFlatRateShippingOptionToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :flatrate_shipping_option, :string
  end
end
