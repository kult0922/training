class AddUserTableUnique < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :account_name, :string, limit: 191
    add_index :users, :account_name, unique: true
  end
end
