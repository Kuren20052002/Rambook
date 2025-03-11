class AddUniqueIndexToHearts < ActiveRecord::Migration[8.0]
  def change
    add_index :hearts, [ :user_id, :heartable_type, :heartable_id ], unique: true
  end
end
