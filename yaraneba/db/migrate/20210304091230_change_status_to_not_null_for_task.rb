class ChangeStatusToNotNullForTask < ActiveRecord::Migration[6.1]
  def change
    change_column_null :tasks, :status, false
  end
end
