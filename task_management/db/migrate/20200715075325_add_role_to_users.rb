class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :integer, limit: 1, null: false, after: :password_digest
  end
end
