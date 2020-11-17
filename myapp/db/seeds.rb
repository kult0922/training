# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(
  name: 'admin',
  email: 'admin@example.com',
  password: 'admin',
)

if Rails.env.development?
  tasks = []
  30.times do |n|
    tasks << Task.new(
      user: user,
      title: "title #{n + 1}",
      description: "description #{n + 1}",
      status: Task.statuses.keys.sample,
      priority: Task.priorities.keys.sample,
    )
  end
  Task.import tasks
end
