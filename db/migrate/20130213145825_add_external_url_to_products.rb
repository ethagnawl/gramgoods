class AddExternalUrlToProducts < ActiveRecord::Migration
  def change
    add_column :products, :external_url, :string
  end
end
