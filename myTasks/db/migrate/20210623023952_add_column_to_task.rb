class AddColumnToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :end_date, :date
    add_column :tasks, :priority, :integer
  end
end
