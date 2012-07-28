class AddingNicknameAndThumbnailToAuthentication < ActiveRecord::Migration
  def up
    add_column :authentications, :nickname, :string
    add_column :authentications, :thumbnail, :string
  end

  def down
    remove_column :authentications, :nickname, :string
    remove_column :authentications, :thumbnail, :string
  end
end
