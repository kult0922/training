class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|

      t.text :name, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
