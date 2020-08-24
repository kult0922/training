class CreateTaskStatus < ActiveRecord::Migration[6.0]
  def change
    create_table :task_statuses do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
