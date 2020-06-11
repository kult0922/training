class CreateTaskLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :task_labels do |t|
      t.references :task
      t.references :label
    end
  end
end
