class AddColumnToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :image_id, :string
  end
end
