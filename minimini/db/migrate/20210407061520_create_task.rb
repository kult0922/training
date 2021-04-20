class CreateTask < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string "name"
      t.text "description"
      t.integer "status", default: 0
      t.integer "user_id"
      t.string "labels"
      t.datetime "due_date", precision: 6, default: -> { "CURRENT_TIMESTAMP(6)" }, null: false
      t.timestamps
    end
  end
end
