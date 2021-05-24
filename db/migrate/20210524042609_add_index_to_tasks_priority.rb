class AddIndexToTasksPriority < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :priority, unique: true
  end
end
