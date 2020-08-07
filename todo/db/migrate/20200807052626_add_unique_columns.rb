class AddUniqueColumns < ActiveRecord::Migration[6.0]
  def up
    change_column :projects, :project_name, :string, null: false, unique: true
    change_column :users, :account_name, :string, null: false, unique: true
  end

  def down
    change_column :project_name, :string, null: false
    change_column :users, :account_name, :string, null: false
  end
end
