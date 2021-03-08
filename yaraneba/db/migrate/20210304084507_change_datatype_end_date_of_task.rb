class ChangeDatatypeEndDateOfTask < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :end_date, :date
  end
end
