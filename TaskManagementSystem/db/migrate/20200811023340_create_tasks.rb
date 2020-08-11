class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.integer :status_id
      t.string :task_name
      t.text :task_description
      t.integer :priority

      t.timestamps
    end
  end
end
