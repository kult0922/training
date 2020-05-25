class AddIndexToDeadline < ActiveRecord::Migration[6.0]
  def up
    add_index :tasks, :deadline
  end

  def down
    remove_index :tasks, :deadline
  end
end
