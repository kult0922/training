class AddUserIdToTasks < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :user, foreign_key: true
    change_column_null :tasks, :user_id, false
  end
end
