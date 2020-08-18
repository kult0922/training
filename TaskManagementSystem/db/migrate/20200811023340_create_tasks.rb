# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.integer :status_id
      t.string :task_name
      t.text :task_description
      t.integer :priority
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
