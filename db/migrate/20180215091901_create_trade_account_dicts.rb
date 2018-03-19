class CreateTradeAccountDicts < ActiveRecord::Migration[5.1]
  def change
    # create_table :trade_account_dicts do |t|
    create_table :trade_account_dicts, :options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|
      t.integer :position_status
      t.references :trade_type, foreign_key: true
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
