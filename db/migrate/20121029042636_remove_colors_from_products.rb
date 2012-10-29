class RemoveColorsFromProducts < ActiveRecord::Migration
  def up
    remove_column :products, :colors
  end

  def down
    add_column :products, :colors, :string
  end
end
