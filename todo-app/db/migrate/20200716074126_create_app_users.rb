# frozen_string_literal: true

class CreateAppUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :app_users do |t|
      t.string :name, null: false
      t.string :hashed_password, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.boolean :suspended, null: false, default: false
      t.timestamps
    end
  end
end
