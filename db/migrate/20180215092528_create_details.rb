class CreateDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :details do |t|
      t.integer :position_status
      t.references :account, foreign_key: true
      t.references :otherside, foreign_key: true

      t.timestamps
    end
  end
end
