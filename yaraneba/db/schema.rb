# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_06_064816) do

  create_table "label_tasks", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "label_id", null: false
    t.bigint "task_id", null: false
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["label_id"], name: "index_label_tasks_on_label_id"
    t.index ["task_id"], name: "index_label_tasks_on_task_id"
  end

  create_table "labels", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_labels_on_user_id"
  end

  create_table "roles", charset: "utf8mb4", force: :cascade do |t|
    t.string "role_name"
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tasks", charset: "utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.text "detail"
    t.integer "priority"
    t.date "end_date"
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", null: false
    t.integer "user_id"
    t.index ["status"], name: "index_tasks_on_status"
    t.index ["title"], name: "index_tasks_on_title"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role_id"
  end

  add_foreign_key "label_tasks", "labels"
  add_foreign_key "label_tasks", "tasks"
  add_foreign_key "labels", "users"
end
