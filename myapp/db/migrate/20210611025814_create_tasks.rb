class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :desc
      t.integer :status
      t.string :label
      t.integer :priority

      t.timestamps
    end
  end
end
