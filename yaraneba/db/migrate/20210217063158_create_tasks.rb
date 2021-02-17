class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :detail
      t.integer :priority
      t.datetime :end_date, limit: 6
      t.datetime :deleted_at, limit: 6

      t.timestamps
    end
  end
end
