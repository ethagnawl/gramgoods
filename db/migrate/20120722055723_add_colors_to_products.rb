class AddColorsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :colors, :string
  end

  def self.down
    remove_column :products, :colors, :string
  end
end
