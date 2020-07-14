class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :task_name
      t.references :project, foreign_key: true
      t.integer :prioperty, null: false
      t.references :assignee, foreign_key: { to_table: :users }
      t.string :assignee_name
      t.references :repoter, foreign_key: { to_table: :users }
      t.string :repoter_name
      t.text :description
      t.date :start_at, null: false
      t.date :end_at, null: false

      t.timestamps
    end
  end
end
