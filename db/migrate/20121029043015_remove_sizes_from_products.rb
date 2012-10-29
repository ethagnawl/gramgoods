class RemoveSizesFromProducts < ActiveRecord::Migration
  def up
    remove_column :products, :sizes
  end

  def down
    add_column :products, :sizes, :string
  end
end
