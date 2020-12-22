class CreateTaskWithLabelTbls < ActiveRecord::Migration[6.1]
  def change
    create_table :task_with_label_tbl do |t|
      t.bigint :task_id , comment: "タスクID", null: false
      t.bigint :label_id, comment: "ラベルID", null: false
      t.timestamps null: false
    end
    add_index :task_with_label_tbl, [:task_id, :label_id], unique: true
    add_foreign_key :task_with_label_tbl, :task_tbl , column: :task_id
    add_foreign_key :task_with_label_tbl, :label_mst, column: :label_id
  end
end
