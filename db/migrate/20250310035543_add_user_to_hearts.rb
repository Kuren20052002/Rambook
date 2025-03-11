class AddUserToHearts < ActiveRecord::Migration[8.0]
  def change
    add_reference :hearts, :user, null: false, foreign_key: true
  end
end
