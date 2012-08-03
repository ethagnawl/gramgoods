class ChangingStoresReturnPolicyFromStringToText < ActiveRecord::Migration
  def up
    change_column :stores, :return_policy, :text
  end

  def down
    change_column :stores, :return_policy, :string
  end
end
