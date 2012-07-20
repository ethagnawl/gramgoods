class AddColumnsToStore < ActiveRecord::Migration
  def self.up
    add_column :stores, :name, :string
    add_column :stores, :url, :string
  end

  def self.down
    remove_column :stores, :name, :string
    remove_column :stores, :url, :string
  end
end
