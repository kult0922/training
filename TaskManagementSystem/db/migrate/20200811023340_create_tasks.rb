# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id, null: false
      t.string :title, null: false, limit: 50
      t.text :description, null: true, limit: 250
      t.integer :priority, default: 1
      t.datetime :deadline, default: Date.today
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
