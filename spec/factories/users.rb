# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { "test@example.com" }
    password_digest { "MyString" }
  end
end
