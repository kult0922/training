class AddProjectTableUnique < ActiveRecord::Migration[6.0]
  def change
    execute("ALTER TABLE projects MODIFY project_name varchar(255) BINARY")
    change_column :projects, :project_name, :string, limit: 191
    add_index :projects, :project_name, unique: true
  end
end
