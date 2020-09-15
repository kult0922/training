# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Please use if necessary
# class ApplicationRecord
#   def self.create_or_update!(attributes)
#     attrs = attributes.dup
#     id = attrs.delete(:id)
#     entity = find_or_initialize_by(id: id)
#     entity.update!(attrs)
#   end
# end

# ユーザ
[
  { id: 1, name: 'Jane Doe', email: 'test1@example.com', password: 'password' },
  { id: 2, name: 'John Doe', email: 'test2@example.com', password: 'password' },
].each do |attrs|
  User.create!(attrs)
end
# タスク
[
  { id: 1, title: 'Jane Doe', user_id: 1 },
  { id: 2, title: 'John Doe', user_id: 2 },
].each do |attrs|
  Task.create!(attrs)
end
