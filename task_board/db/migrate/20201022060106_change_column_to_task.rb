class ChangeColumnToTask < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :name, :string, null: false, limit: 50
  end
end
