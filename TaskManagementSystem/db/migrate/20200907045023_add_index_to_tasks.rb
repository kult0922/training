class AddIndexToTasks < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, [:user_id, :status]
    add_foreign_key :tasks, :users
  end
end
