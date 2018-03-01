class AddUserToJournals < ActiveRecord::Migration[5.1]
  def change
    add_reference :journals, :user, foreign_key: true
  end
end