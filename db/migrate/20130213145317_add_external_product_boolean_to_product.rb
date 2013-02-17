class AddExternalProductBooleanToProduct < ActiveRecord::Migration
  def change
    add_column :products, :external, :boolean, :default => false
  end
end
