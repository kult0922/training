class AddColumnTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :due_date, :date, after: 'description', comment: '終了期限'
  end
end
