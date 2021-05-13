class AddNameToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :name, :text
  end
end
