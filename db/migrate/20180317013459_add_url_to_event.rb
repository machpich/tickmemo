class AddUrlToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :url, :text
  end
end
