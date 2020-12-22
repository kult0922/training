# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 1.権限マスタ
AuthorityMst.create!(
  authority_mst_id: 1,
  authority_div:    '0',
  authority_name:   "システム管理者"
)

# 2.ユーザテーブル
UsersTbl.create!(
  users_tbl_id: 1,
  user_id:      "yokuno",
  user_name:    "奥野",
  password:     "pass",
  authority_id: 1
)

# 3.ラベルマスタ
LabelMst.create!(
  label_mst_id: 1,
  user_id:      1,
  label_no:     1,
  label_name:   "テストラベル1"
)
# 4.タスクテーブル
TaskTbl.create!(
  task_tbl_id:  1,
  user_id:      1,
  task_no:      1,
  task_name:    "テストタスク1",
  task_details: "タスク説明1",
  deadline:     "2020-12-22 20:08:33",
  status:       '0',
  priority:     '0',
  creation_date:"2020-10-02 02:04:05"
)

# 5.タスクテーブル-ラベルマスタ紐付テーブル
TaskWithLabelTbl .create!(
  task_with_label_tbl_id: 1,
  user_id:                1,
  task_id:                1,
  label_id:               1
)