class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.integer :task_id
      t.string :label, limit: 100

      t.timestamps
    end
  end
end
