# frozen_string_literal: true

5.times do |n|
  User.create!(
    account_name: "user#{n}",
    password: "seedtest",
    password_confirmation: 'seedtest'
  )
end
