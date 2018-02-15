class CreateMemos < ActiveRecord::Migration[5.1]
  def change
    create_table :memos do |t|
      t.string :body
      t.string :memoable_type
      t.integer :memoable_id

      t.timestamps
    end
  end
end
