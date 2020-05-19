class ChangeColumnToTasks < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :priority, :integer, limit: 1, null: false
    change_column :tasks, :status, :integer, limit: 1, default: nil, null: false
  end

  def down
    change_column :tasks, :priority, :integer, limit: 1
    change_column :tasks, :status, :integer, limit: 1, default: 0
  end
end
