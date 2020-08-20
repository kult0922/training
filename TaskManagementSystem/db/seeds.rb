# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

3.times do |num|
  3.times do |n|
    Task.create(name: "タスクの名前#{n}", description: "タスクの説明#{n}", priority: n, deadline: Time.strptime("2020年10月#{n+1}日 12:13:23", '%Y年%m月%d日 %H:%M:%S'), status: n)
  end
end