class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :task_name, null: false
      t.references :project, foreign_key: true
      t.integer :priority, null: false
      t.references :assignee, foreign_key: { to_table: :users }
      t.string :assignee_name
      t.references :reporter, foreign_key: { to_table: :users }
      t.string :reporter_name
      t.text :description
      t.date :started_at, null: false
      t.date :finished_at, null: false

      t.timestamps
    end
  end
end
