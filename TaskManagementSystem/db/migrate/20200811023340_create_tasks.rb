# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.integer :priority
      t.datetime :deadline
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
