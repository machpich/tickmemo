class CreateTradeTypes < ActiveRecord::Migration[5.1]
  def change
    # create_table :trade_types do |t|
    create_table :trade_types, options: 'ENGINE=InnoDB CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC' do |t|
      t.string :trade_name
      t.string :short_name

      t.timestamps
    end
  end
end
