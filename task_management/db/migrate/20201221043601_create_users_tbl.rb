class CreateUsersTbl < ActiveRecord::Migration[6.1]
  def change
    create_table :users_tbl, id: false do |t|
      t.bigint :users_tbl_id, comment: "ユーザテーブルID"          , null: false, primary_key: true
      t.string :user_id     , comment: "ユーザID"                  , null: false, limit: 12
      t.string :user_name   , comment: "ユーザ名"                  , null: false
      t.string :password    , comment: "パスワード(暗号化して登録)", null: false, limit: 12
      t.bigint :authority_id, comment: "権限ID"                    , null: false
    end
    add_index       :users_tbl, :user_id, unique: true
    add_foreign_key :users_tbl, :authority_mst, column: :authority_id, primary_key: :authority_mst_id
  end
end
