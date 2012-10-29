class RemoveInstagramTagsFromProducts < ActiveRecord::Migration
  def up
    remove_column :products, :instagram_tag
  end

  def down
    add_column :products, :instagram_tag, :string
  end
end
