class AddPhotosToProduct < ActiveRecord::Migration
  def change
    add_column :products, :photos, :string
  end
end
