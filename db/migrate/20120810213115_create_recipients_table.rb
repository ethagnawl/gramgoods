class CreateRecipientsTable < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.timestamps
      t.integer 'order_id'
      t.string 'first_name'
      t.string 'last_name'
      t.string 'email_address'
      t.string 'street_address_one'
      t.string 'street_address_two'
      t.string 'city'
      t.string 'state'
      t.string 'postal_code'
    end

    add_index "recipients", ["order_id"], :name => "index_recipients_on_order_id"
  end
end
