class AddColorToColors < ActiveRecord::Migration
  def change
    add_column :colors, :color, :string
  end
end
