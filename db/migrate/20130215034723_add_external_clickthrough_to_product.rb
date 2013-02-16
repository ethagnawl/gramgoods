class AddExternalClickthroughToProduct < ActiveRecord::Migration
  def change
    add_column :products, :external_clickthroughs, :integer, :default => 0
  end
end
