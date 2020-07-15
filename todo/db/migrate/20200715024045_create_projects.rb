class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :project_name, null: false
      t.integer :status, null: false
      t.text :description
      t.date :started_at
      t.date :finished_at

      t.timestamps
    end
  end
end
