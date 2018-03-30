class CreateOthersides < ActiveRecord::Migration[5.1]
  def change
    # create_table :othersides do |t|
    create_table :othersides, :options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|
      t.string :otherside_name
      t.text :url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
