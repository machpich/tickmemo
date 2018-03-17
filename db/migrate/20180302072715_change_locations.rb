class ChangeLocations < ActiveRecord::Migration[5.1]
  def change
    #create_table :events_locations, id: false do |t|
    create_table :events_locations, id: false, :options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|
      t.references :event, index: true, null: false
      t.references :location, index: true, null: false
    end
  end
end
