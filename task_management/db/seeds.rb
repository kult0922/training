# frozen_string_literal: true

# 1.権限マスタ
Authority.create!(
  role: 0,
  name: 'Administrator',
)

# 2.ユーザテーブル
User.create!(
  login_id:     'yokuno',
  name:         '奥野',
  password:     'pass',
  authority_id: 1,
)

# 3.ラベルマスタ
Label.create!(
  user_id: 1,
  name:    'テストラベル1',
)

# 4.タスクテーブル
5.times do |n|
  Task.create!(
    user_id:       1,
    name:          "テストタスク#{n + 1}",
    details:       "タスク説明#{n + 1}",
    deadline:      '2020-12-22 20:08:33',
    status:        1,
    priority:      1,
    creation_date: '2020-10-02 02:04:05',
  )
end

# 5.タスクテーブル-ラベルマスタ紐付テーブル
5.times do |n|
  TaskLabelRelation.create!(
    task_id:  n + 1,
    label_id: 1,
  )
end
