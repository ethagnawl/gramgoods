class AddPurchaseTypeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :purchase_type, :string, :default => 'buy-now', :required => true
  end
end
