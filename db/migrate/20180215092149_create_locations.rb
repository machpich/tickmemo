class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
    # create_table :locations, :options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|
      t.string :place_name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
