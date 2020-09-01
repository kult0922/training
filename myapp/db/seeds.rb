# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# タスク
[
  { id: 1, title: '名前1', description: '説明文1', due_date: '2020-04-03', status: 0 },
  { id: 2, title: '名前2', description: '説明文2', due_date: '2020-04-02', status: 1 },
  { id: 3, title: '名前3', description: '説明文3', due_date: '2020-04-01', status: 2 },
].each do |attrs|
  Task.create(attrs)
end
