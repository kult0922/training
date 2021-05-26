class AddIndexToTasksStatePriority < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, [:aasm_state, :priority]
  end
end
