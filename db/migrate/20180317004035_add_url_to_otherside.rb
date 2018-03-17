class AddUrlToOtherside < ActiveRecord::Migration[5.1]
  def change
    add_column :othersides, :url, :text
  end
end
