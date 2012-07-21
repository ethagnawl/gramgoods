class AddStatusToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :status, :string, :default => 'draft'
  end

  def self.down
    remove_column :products, :status, :string, :default => 'draft'
  end
end
