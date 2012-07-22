class AddSizesToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :sizes, :string
  end

  def self.down
    remove_column :products, :sizes, :string
  end
end
