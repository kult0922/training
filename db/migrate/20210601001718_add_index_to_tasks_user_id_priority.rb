class AddIndexToTasksUserIdPriority < ActiveRecord::Migration[6.1]
  def change
    remove_index :tasks, :priority
    add_index :tasks, [:user_id, :priority], unique: true
  end
end
