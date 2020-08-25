class ChangeTaskStatusColumn < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :status, :integer, after: :priority
  end

  def down
    change_column :tasks, :status, :integer
  end
end
