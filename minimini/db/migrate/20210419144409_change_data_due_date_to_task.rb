class ChangeDataDueDateToTask < ActiveRecord::Migration[6.1]
  def up
    change_column :tasks, :due_date, :date
  end

  def down
    change_column :tasks, :due_date, :datetime
  end
end
