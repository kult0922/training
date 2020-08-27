class ChangeColumnOnTask < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :task_status_id, false
  end
end
