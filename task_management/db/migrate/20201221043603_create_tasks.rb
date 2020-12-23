class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.bigint   :user_id      , comment: "ユーザID"                          , null: false
      t.string   :name         , comment: "タスク名"                          , null: false
      t.string   :details      , comment: "タスク詳細"
      t.datetime :deadline     , comment: "終了期限"                          , null: false
      t.integer  :status       , comment: "ステータス(0:未着手 1:着手 2:完了)", null: false, limit: 1
      t.integer  :priority     , comment: "優先順位(0:低 1:中 2:高)"          , null: false, limit: 1
      t.datetime :creation_date, comment: "作成日時"                          , null: false
      t.timestamps null: false
    end
    add_foreign_key :tasks, :users, column: :user_id
  end
end
