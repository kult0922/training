class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description
      t.date :end_date
      t.integer :priority, limit: 1
      t.integer :status, limit: 1
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
