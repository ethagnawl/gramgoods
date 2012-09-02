class AddInstagramTagToInstagramTags < ActiveRecord::Migration
  def change
    add_column :instagram_tags, :instagram_tag, :string
  end
end
