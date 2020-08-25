class RemoveTaskColumns < ActiveRecord::Migration[6.0]
  def up
    remove_column :tasks, :assignee_name, :string
    remove_column :tasks, :reporter_name, :string
  end

  def down
    add_column :tasks, :assignee_name, :string
    add_column :tasks, :reporter_name, :string
  end
end
