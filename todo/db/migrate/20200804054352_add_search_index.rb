class AddSearchIndex < ActiveRecord::Migration[6.0]
  def up
    add_index :tasks, :status
    add_index :tasks, :priority
    add_index :tasks, :finished_at
  end

  def down
    remove_index :tasks, :status
    remove_index :tasks, :priority
    remove_index :tasks, :finished_at
  end
end
