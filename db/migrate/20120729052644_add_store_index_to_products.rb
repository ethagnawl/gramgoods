class AddStoreIndexToProducts < ActiveRecord::Migration
  def change
    add_index :products, :store_id
  end
end
