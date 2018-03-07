class CreateDetailsJournals < ActiveRecord::Migration[5.1]
  def change
    create_table :details_journals, id: false do |t|
      t.references :detail, foreign_key: true, null: false
      t.references :journal, foreign_key: true, null: false
    end
  end
end
