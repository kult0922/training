class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title, limit: 100
      t.integer :status, limit: 2
      t.text :detail
      t.timestamp :end_date

      t.timestamps
    end
  end
end
