class CreateJournals < ActiveRecord::Migration[5.1]
  def change
    create_table :journals do |t|
      t.date :trade_date
      t.integer :figure
      t.references :trade_type, foreign_key: true
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
