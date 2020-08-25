class RenameDiscriptionColumnToTasks < ActiveRecord::Migration[6.0]
  def change
    rename_column :tasks, :discription, :description
  end
end
