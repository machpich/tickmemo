class ChangeLocations < ActiveRecord::Migration[5.1]
  def change
    add_reference :locations, :user, foreign_key: true
    remove_column :locations, :event_id

    create_table :events_locations, id: false do |t|
      t.references :event, index: true, null: false
      t.references :location, index: true, null: false
    end
  end
end
