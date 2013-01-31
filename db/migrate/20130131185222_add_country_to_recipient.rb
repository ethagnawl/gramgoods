class AddCountryToRecipient < ActiveRecord::Migration
  def change
    add_column :recipients, :country, :string, :default => "United States"
  end
end
