class CreateHearts < ActiveRecord::Migration[8.0]
  def change
    create_table :hearts do |t|
      t.references :heartable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
