class RemoveTableToDetailsJournal < ActiveRecord::Migration[5.1]
  def change
    drop_table :details_journals
  end
end
