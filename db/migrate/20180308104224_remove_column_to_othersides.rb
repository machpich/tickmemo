class RemoveColumnToOthersides < ActiveRecord::Migration[5.1]
  def change
    remove_column(:othersides, :type)
  end
end
