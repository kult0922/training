ActiveRecord::Schema.define(version: 2021_02_25_130833) do

  create_table "tasks", charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.text "detail"
    t.integer "priority"
    t.datetime "end_date", precision: 6
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
  end

end
