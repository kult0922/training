# frozen_string_literal: true

User.create!(
  account_name: "user1",
  password: 'seedtest',
  password_confirmation: 'seedtest',
  admin: :true
)

(2..5).each do |n|
  User.create!(
    account_name: "user#{n}",
    password: 'seedtest',
    password_confirmation: 'seedtest',
    admin: :false
  )
end
