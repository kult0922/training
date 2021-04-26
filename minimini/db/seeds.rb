# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do |n|
    User.create!(
        email: "trainee#{n + 1}@rakuten.com",
        name: "研修 太郎#{n + 1}",
        password: "password#{n + 1}",
    )
end

status = [ 1, 2, 3, 4 ]
labels = [ 1, 2, 3, 4 ]

10.times do |m|
    10.times do |n|
        Task.create!(
            name: "タスク#{n + 1}_#{m + 1}",
            description: "タスク内容#{n + 1}",
            status: status.sample,
            labels: labels.sample,
            due_date: DateTime.now + 1.week,
            user_id: m + 1,
        )
    end
end
