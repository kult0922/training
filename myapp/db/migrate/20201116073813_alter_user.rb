class AlterUser < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :name, :string, limit: 30, null: false
    add_index :users, :name, unique: true
    add_column :users, :email, :string, limit: 255, null: false
    add_index :users, :email, unique: true
    rename_column :users, :encrypted_password, :password_digest
    change_column :users, :password_digest, :string, null: false
  end

  def down
    remove_index :users, column: :name
    rename_column :users, :password_digest, :encrypted_password
    remove_column :users, :email
    change_column :users, :name, :string
  end
end
