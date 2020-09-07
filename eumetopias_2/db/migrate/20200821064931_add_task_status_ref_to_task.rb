class AddTaskStatusRefToTask < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :task_status, foreigh_key: true
  end
end
