class ChangeColumnToTasks < ActiveRecord::Migration[6.1]
  def up
    change_column_null :tasks, :title, false
    change_column :tasks, :title, :string, limit: 30
    change_column_null :tasks, :priority, false
  end
end
