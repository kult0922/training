class AlterTask < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :title, :string, :limit => 100
    change_column :tasks, :description, :string, :limit => 2000
    change_column :tasks, :status, :integer, :limit => 1
    change_column :tasks, :priority, :integer, :limit => 1
  end
end
