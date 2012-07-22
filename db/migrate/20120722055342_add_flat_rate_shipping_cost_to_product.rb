class AddFlatRateShippingCostToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :flat_rate_shipping_cost, :decimal
  end

  def self.down
    remove_column :products, :flat_rate_shipping_cost, :decimal
  end
end
