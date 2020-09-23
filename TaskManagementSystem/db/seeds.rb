# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ユーザー
30.times do |n|
  User.create(
    last_name: 'タスクユーザー',
    first_name: "太郎#{n}",
    email: "task_user_taro#{n}@example.com",
    password: "password#{n}",
    password_confirmation: "password#{n}",
  )
end

# タスク
k = 0
10.times do |_num|
  3.times do |n|
    Task.create(
      user_id: n + 1,
      title: "タスクの名前#{n + k}",
      description: "タスクの説明#{n + k}",
      priority: n + k,
      deadline: Time.strptime("2020年10月#{n + 1 + k}日 12:13:23", '%Y年%m月%d日 %H:%M:%S'),
      status: n + 1,
    )
  end
  k += 3
end
