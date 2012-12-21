class AddAllowedToCreateProductsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :allowed_to_create_products, :boolean, default: false
  end
end
