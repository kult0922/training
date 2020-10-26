class ChangeColumnToTask < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :name, :string, null: false, limit: 50
  end

  def down
    change_column :tasks, :name, :string, null: false
  end
end
