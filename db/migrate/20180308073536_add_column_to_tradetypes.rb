class AddColumnToTradetypes < ActiveRecord::Migration[5.1]
  def change
    add_column :trade_types, :short_name, :string
  end
end
