# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, index: { unique: true }, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end