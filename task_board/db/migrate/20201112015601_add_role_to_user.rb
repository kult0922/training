class AddRoleToUser < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :role, :integer, limit: 1, null: false
  end

  def down
    remove_column :users, :role, :integer, limit: 1, null: false
  end
end
