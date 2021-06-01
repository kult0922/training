class AddIndexToTasksUserIdStatePriority < ActiveRecord::Migration[6.1]
  def change
    remove_index :tasks, [:aasm_state, :priority]
    add_index :tasks, [:user_id, :aasm_state, :priority]
  end
end
