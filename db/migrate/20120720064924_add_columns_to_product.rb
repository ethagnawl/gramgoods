class AddColumnsToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :name, :string
    add_column :products, :description, :string
    add_column :products, :price, :decimal, :precision => 8, :scale => 2
    add_column :products, :quantity, :integer
  end

  def self.down
    remove_column :products, :name, :string
    remove_column :products, :description, :string
    remove_column :products, :price, :decimal, :precision => 8, :scale => 2
    remove_column :products, :quantity, :integer
  end
end
