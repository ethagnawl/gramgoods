class AddReturnPolicyToStore < ActiveRecord::Migration
  def change
    add_column :stores, :return_policy, :string
  end
end
