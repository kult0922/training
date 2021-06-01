# frozen_string_literal: true

require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(
  name: 'john',
  email: 'john.doe@example.com',
  password: 'Ab12345+',
  password_confirmation: 'Ab12345+',
)

11.times do |i|
  user.tasks.create!(
    title: Faker::Lorem.word,
    description: Faker::Lorem.sentence,
    priority: i + 1,
    aasm_state: Task.aasm_states.keys.sample,
    user: user,
  )
end
