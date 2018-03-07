class RemoveColumnFromEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column(:events, :image)
  end
end
