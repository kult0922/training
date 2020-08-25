# frozen_string_literal: true

(1..5).each do |n|
  User.create!(
    account_name: "user#{n}",
    password: 'seedtest',
    password_confirmation: 'seedtest'
  )
end
