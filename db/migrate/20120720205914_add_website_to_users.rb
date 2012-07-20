class AddWebsiteToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :website, :string
  end

  def self.down
    remove_column :users, :website, :string
  end
end
