class CreateTaskTbl < ActiveRecord::Migration[6.1]
  def change
    create_table :task_tbl, id: false do |t|
      t.bigint   :task_tbl_id             , comment: "タスクテーブルID"                  , null: false, primary_key: true
      t.bigint   :user_id                 , comment: "ユーザID"                          , null: false
      t.integer  :task_no                 , comment: "タスクNo"                          , null: false
      t.string   :task_name               , comment: "タスク名"                          , null: false
      t.string   :task_details            , comment: "タスク詳細"
      t.datetime :deadline                , comment: "終了期限"                          , null: false
      t.column   :status       ,:"CHAR(1)", comment: "ステータス(0:未着手 1:着手 2:完了)", null: false
      t.column   :priority     ,:"CHAR(1)", comment: "優先順位(0:低 1:中 2:高)"          , null: false
      t.datetime :creation_date           , comment: "作成日時"                          , null: false
    end
    add_index       :task_tbl, [:user_id, :task_no], unique: true
    add_foreign_key :task_tbl, :users_tbl, column: :user_id, primary_key: :users_tbl_id
  end
end
