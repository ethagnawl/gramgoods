class AddDomesticPrefixToFlatrateShippingOption < ActiveRecord::Migration
  def change
    rename_column :products, :flatrate_shipping_cost, :domestic_flatrate_shipping_cost
  end
end
