class AddUserIdToTasks < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :user, foreign_key: true, null: false, after: "status", comment: 'ユーザID'
  end
end
