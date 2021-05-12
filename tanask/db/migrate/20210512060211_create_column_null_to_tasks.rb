class CreateColumnNullToTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :column_null_to_tasks do |t|
      change_column_null :tasks, :name, false
      change_column_null :tasks, :description, false

      t.timestamps
    end
  end
end
