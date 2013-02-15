class AddExternalClickthroughToProduct < ActiveRecord::Migration
  def change
    add_column :products, :external_clickthroughs, :integer
  end
end
