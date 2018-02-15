class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :account_name
      t.integer :character_status

      t.timestamps
    end
  end
end
