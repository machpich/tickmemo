class RemoveUserToOtherside < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :othersides, column: :user
  end
end
