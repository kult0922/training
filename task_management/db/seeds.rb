# frozen_string_literal: true

# 1.権限マスタ
Authority.create!(
  role: 0,
  name: '管理者',
)

Authority.create!(
  role: 1,
  name: '一般',
)

# 2.ユーザテーブル
User.create!(
  login_id:     'yokuno',
  name:         '奥野',
  password:     'pass',
  authority_id: 1,
)

User.create!(
  login_id:     'yokuno2',
  name:         '奥野2',
  password:     'pass2',
  authority_id: 2,
)

30.times do |n|
  User.create!(
    login_id:     "g_user_#{n + 1}",
    name:         "一般テストユーザちゃん_#{n + 1}",
    password:     'password',
    authority_id: 2,
    )
end

# 3.ラベルマスタ
Label.create!(
  user_id: 1,
  name:    'テストラベル1',
)

Label.create!(
  user_id: 2,
  name:    'テストラベル2',
)

# 4.タスクテーブル
30.times do |n|
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

5.times do |n|
  Task.create!(
    user_id:       2,
    name:          "テストタスク#{n + 1}",
    details:       "タスク説明#{n + 1}",
    deadline:      '2020-12-25 20:08:33',
    status:        1,
    priority:      1,
    creation_date: '2020-10-05 02:04:05',
  )
end

# 5.タスクテーブル-ラベルマスタ紐付テーブル
30.times do |n|
  TaskLabelRelation.create!(
    task_id:  n + 1,
    label_id: 1,
  )
end

5.times do |n|
  TaskLabelRelation.create!(
    task_id:  n + 31,
    label_id: 2,
  )
end
