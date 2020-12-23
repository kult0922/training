class CreateTaskLabelRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :task_label_relations do |t|
      t.bigint :task_id , comment: "タスクID", null: false
      t.bigint :label_id, comment: "ラベルID", null: false
      t.timestamps null: false
    end
    add_index :task_label_relations, [:task_id, :label_id], unique: true
    add_foreign_key :task_label_relations, :tasks , column: :task_id
    add_foreign_key :task_label_relations, :labels, column: :label_id
  end
end
