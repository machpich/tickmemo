class AddColumnToDetails < ActiveRecord::Migration[5.1]
  def change
    add_reference :details, :journal, foreign_key: true
  end
end
