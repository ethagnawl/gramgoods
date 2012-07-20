class AddColumnsToAuthentication < ActiveRecord::Migration
  def self.up
    add_column :authentications, :user_id, :integer
    add_column :authentications, :provider, :string
    add_column :authentications, :uid, :string
  end

  def self.down
    remove_column :authentications, :user_id, :integer
    remove_column :authentications, :provider, :string
    remove_column :authentications, :uid, :string
  end
end
