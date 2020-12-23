class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :login_id    , comment: "ログインID"                , null: false, limit: 12
      t.string :name        , comment: "ユーザ名"                  , null: false
      t.string :password    , comment: "パスワード(暗号化して登録)", null: false, limit: 12
      t.bigint :authority_id, comment: "権限ID"                    , null: false
      t.timestamps null: false
    end
    add_index :users, :login_id, unique: true
    add_foreign_key :users, :authorities, column: :authority_id
  end
end
