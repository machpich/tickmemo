class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.string :seat_type
      t.boolean :fix
      t.boolean :check
      t.references :location, foreign_key: true
      t.references :event, foreign_key: true
      t.references :otherside, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
