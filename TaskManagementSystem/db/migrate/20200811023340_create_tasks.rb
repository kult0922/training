# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.bigint :user_id, null: false
      t.string :title, null: false, limit: 50
      t.text :description, null: true, limit: 250
      t.integer :priority, default: 1
      t.datetime :deadline
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :tasks, [:user_id, :title, :status]
    add_foreign_key :tasks, :users
  end
end
