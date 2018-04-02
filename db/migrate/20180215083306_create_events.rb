class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    # create_table :events do |t|
    create_table :events, options: 'ENGINE=InnoDB CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC' do |t|
      t.string :program
      t.string :performer
      t.date :date_start
      t.date :date_end
      t.string :image_id
      t.text :url
      t.references :user

      t.timestamps
    end
  end
end
