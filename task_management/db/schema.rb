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

ActiveRecord::Schema.define(version: 2020_12_21_043604) do

  create_table "authority_mst", charset: "utf8mb4", force: :cascade do |t|
    t.integer "div", limit: 1, null: false, comment: "権限区分"
    t.string "name", null: false, comment: "権限名"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["div"], name: "index_authority_mst_on_div", unique: true
  end

  create_table "label_mst", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザID"
    t.integer "no", null: false, comment: "ラベルNo"
    t.string "name", null: false, comment: "ラベル名"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "no"], name: "index_label_mst_on_user_id_and_no", unique: true
  end

  create_table "task_tbl", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザID"
    t.integer "no", null: false, comment: "タスクNo"
    t.string "name", null: false, comment: "タスク名"
    t.string "details", comment: "タスク詳細"
    t.datetime "deadline", null: false, comment: "終了期限"
    t.integer "status", limit: 1, null: false, comment: "ステータス(0:未着手 1:着手 2:完了)"
    t.integer "priority", limit: 1, null: false, comment: "優先順位(0:低 1:中 2:高)"
    t.datetime "creation_date", null: false, comment: "作成日時"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "no"], name: "index_task_tbl_on_user_id_and_no", unique: true
  end

  create_table "task_with_label_tbl", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "task_id", null: false, comment: "タスクID"
    t.bigint "label_id", null: false, comment: "ラベルID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["label_id"], name: "fk_rails_0d9bed0288"
    t.index ["task_id", "label_id"], name: "index_task_with_label_tbl_on_task_id_and_label_id", unique: true
  end

  create_table "users_tbl", charset: "utf8mb4", force: :cascade do |t|
    t.string "user_id", limit: 12, null: false, comment: "ユーザID"
    t.string "name", null: false, comment: "ユーザ名"
    t.string "password", limit: 12, null: false, comment: "パスワード(暗号化して登録)"
    t.bigint "authority_id", null: false, comment: "権限ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authority_id"], name: "fk_rails_40f117296f"
    t.index ["user_id"], name: "index_users_tbl_on_user_id", unique: true
  end

  add_foreign_key "label_mst", "users_tbl", column: "user_id"
  add_foreign_key "task_tbl", "users_tbl", column: "user_id"
  add_foreign_key "task_with_label_tbl", "label_mst", column: "label_id"
  add_foreign_key "task_with_label_tbl", "task_tbl", column: "task_id"
  add_foreign_key "users_tbl", "authority_mst", column: "authority_id"
end
