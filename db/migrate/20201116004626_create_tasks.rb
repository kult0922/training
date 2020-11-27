class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title, limit: 100, null: false
      t.integer :status, limit: 2, null: false
      t.text :detail, null: false
      t.timestamp :end_date

      t.timestamps
    end
  end
end
