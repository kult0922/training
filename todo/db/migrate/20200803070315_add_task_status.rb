class AddTaskStatus < ActiveRecord::Migration[6.0]
  def up
    add_column :tasks, :status, :integer
  end

  def down
    remove_column :tasks, :status, :integer
  end
end
