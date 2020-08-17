class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.integer :status_id
      t.string :name
      t.text :description
			t.integer :priority
			t.datetime :deadline

      t.timestamps
    end
  end
end
