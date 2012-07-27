class AddingUnlimitedQuantityToProducts < ActiveRecord::Migration
  def change
    add_column :products, :unlimited_quantity, :boolean
  end
end
