class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string  :name, limit: 50, null: false 
      t.text    :description, null: false
      t.integer :status_code, null: false, default: 0
      t.integer :priority_code, null: false, default: 1
      t.boolean :deleted_flag, null: false, default: 0
      t.date    :expire_date, null: false
      t.bigint  :resiter_user_id, null: false
      t.timestamps
    end
    add_index :tasks, [:id, :deleted_flag]
  end
end
