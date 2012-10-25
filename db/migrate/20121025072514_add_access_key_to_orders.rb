class AddAccessKeyToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :access_key, :string
  end
end
