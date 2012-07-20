class AddThumbnailToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :thumbnail, :string
  end

  def self.down
    remove_column :users, :thumbnail, :string
  end
end
