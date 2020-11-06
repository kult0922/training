class AddUniqueToTaskLabel < ActiveRecord::Migration[6.0]
  def change
    add_index :task_labels, [:task_id, :label_id], :name => 'unique_task_label', :unique => true
  end
end
