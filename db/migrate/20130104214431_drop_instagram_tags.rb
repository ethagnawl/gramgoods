class DropInstagramTags < ActiveRecord::Migration
  def up
    drop_table :instagram_tags
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
