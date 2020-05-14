class AddStatusTasks < ActiveRecord::Migration[6.0]
  def up
    add_column :tasks, :status, :integer, null: false, default: 0, :after => :deadline
  end

  def down
    remove_column :tasks, :status, :integer
  end
end
