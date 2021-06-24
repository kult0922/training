class AddColumnToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :end_date, :date, after: :description
    add_column :tasks, :priority, :integer, after: :end_date
  end
end
