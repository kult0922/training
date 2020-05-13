class AddDeadlineTasks < ActiveRecord::Migration[6.0]
  def up
    add_column :tasks, :deadline, :date, :after => :memo
  end

  def down
    remove_column :tasks, :deadline, :date
  end
end
