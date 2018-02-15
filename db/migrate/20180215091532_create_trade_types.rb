class CreateTradeTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_types do |t|
      t.string :trade_name

      t.timestamps
    end
  end
end
