class CreateOthersides < ActiveRecord::Migration[5.1]
  def change
    create_table :othersides do |t|
      t.string :otherside_name
      t.integer :type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
