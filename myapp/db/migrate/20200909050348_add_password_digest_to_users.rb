class AddPasswordDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_digest, :string, null: false, after: 'email', comment: '暗号化パスワード'
  end
end
