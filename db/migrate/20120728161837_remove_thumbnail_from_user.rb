class RemoveThumbnailFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :thumbnail
  end

  def down
    add_column :users, :thumbnail, :string
  end
end
