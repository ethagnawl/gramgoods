class RemoveProductImages < ActiveRecord::Migration
  def up
    drop_table :product_images
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
