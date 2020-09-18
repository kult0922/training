class AddIndexToUserRoles < ActiveRecord::Migration[6.0]
  def change
    add_index :user_roles, [:user_id, :role_id]
    add_foreign_key :user_roles, :users
    add_foreign_key :user_roles, :roles
  end
end
