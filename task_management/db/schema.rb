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

ActiveRecord::Schema.define(version: 2021_01_14_052353) do

  create_table "authorities", charset: "utf8mb4", force: :cascade do |t|
    t.integer "role", null: false, comment: "権限区分"
    t.string "name", null: false, comment: "権限名"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "labels", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザID"
    t.string "name", null: false, comment: "ラベル名"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "fk_rails_9ea980b469"
  end

  create_table "task_label_relations", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "task_id", null: false, comment: "タスクID"
    t.bigint "label_id", null: false, comment: "ラベルID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["label_id"], name: "fk_rails_1c09076d1e"
    t.index ["task_id", "label_id"], name: "index_task_label_relations_on_task_id_and_label_id", unique: true
  end

  create_table "tasks", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザID"
    t.string "name", null: false, comment: "タスク名"
    t.string "details", comment: "タスク詳細"
    t.datetime "deadline", null: false, comment: "終了期限"
    t.integer "status", limit: 1, null: false, comment: "ステータス(0:未着手 1:着手 2:完了)"
    t.integer "priority", limit: 1, null: false, comment: "優先順位(0:低 1:中 2:高)"
    t.datetime "creation_date", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "fk_rails_4d2a9e4d7e"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "login_id", limit: 12, null: false, comment: "ログインID"
    t.string "name", null: false, comment: "ユーザ名"
    t.string "password", limit: 12, null: false, comment: "パスワード(暗号化して登録)"
    t.bigint "authority_id", null: false, comment: "権限ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authority_id"], name: "fk_rails_eeedfb3811"
    t.index ["login_id"], name: "index_users_on_login_id", unique: true
  end

  add_foreign_key "labels", "users"
  add_foreign_key "task_label_relations", "labels"
  add_foreign_key "task_label_relations", "tasks"
  add_foreign_key "tasks", "users"
  add_foreign_key "users", "authorities"
end
