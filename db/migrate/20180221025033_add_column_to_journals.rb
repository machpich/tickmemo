class AddColumnToJournals < ActiveRecord::Migration[5.1]
  def change
    add_reference :journals, :otherside, foreign_key: true
  end
end
