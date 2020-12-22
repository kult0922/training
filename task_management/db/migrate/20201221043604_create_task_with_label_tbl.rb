class CreateTaskWithLabelTbl < ActiveRecord::Migration[6.1]
  def change
    create_table :task_with_label_tbl, id: false do |t|
      t.bigint :task_with_label_tbl_id, comment: "タスクテーブル-ラベルマスタ紐付テーブルID", null: false, primary_key: true
      t.bigint :user_id               , comment: "ユーザID"                                 , null: false
      t.bigint :task_id               , comment: "タスクID"                                 , null: false
      t.bigint :label_id              , comment: "ラベルID"                                 , null: false
    end
    add_index :task_with_label_tbl, [:user_id, :task_id, :label_id], unique: true
    add_foreign_key :task_with_label_tbl, :users_tbl, column: :user_id , primary_key: :users_tbl_id
    add_foreign_key :task_with_label_tbl, :task_tbl , column: :task_id , primary_key: :task_tbl_id
    add_foreign_key :task_with_label_tbl, :label_mst, column: :label_id, primary_key: :label_mst_id
  end
end
