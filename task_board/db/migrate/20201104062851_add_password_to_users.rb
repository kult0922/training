class AddPasswordToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :password_digest, :string, null: false
    remove_column :users, :password, :string, null: false
  end

  def down
    remove_column :users, :password_digest, :string, null: false
    add_column :users, :password, :string, null: false
  end
end
