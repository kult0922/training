class AddNullConstraint < ActiveRecord::Migration[6.0]
  def up
    change_column :projects, :project_name, :string, limit: 191, null: false
    change_column :users, :account_name, :string, limit: 191, null: false
  end

  def down 
    change_column :projects, :project_name, :string, limit: 191
    change_column :users, :account_name, :string, limit: 191
  end
end
