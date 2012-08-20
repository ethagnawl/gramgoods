class RemovePhotosFromProduct < ActiveRecord::Migration
  def up
    remove_column :products, :photos
  end

  def down
    add_column :products, :photos
  end
end
