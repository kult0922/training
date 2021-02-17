class ChangeColumnToUsers < ActiveRecord::Migration[6.1]
  def up
    change_column :users, :password_digest, :string,
                  comment: "パスワード(暗号化して登録)" , null: false
  end

  def down
    change_column :users, :password_digest, :string,
                  comment: "パスワード(暗号化)" , null: false, limit: 12
  end
end
