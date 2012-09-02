class CreateInstagramTags < ActiveRecord::Migration
  def change
    create_table :instagram_tags do |t|

      t.timestamps
      t.integer 'product_id'
    end

    add_index "instagram_tags", ["product_id"], :name => "index_instagram_tags_on_product_id"
  end
end
