class AddingInstagramTagToProducts < ActiveRecord::Migration
  def up
    add_column :products, :instagram_tag, :string
  end

  def down
    remove_column :products, :instagram_tag, :string
  end
end
