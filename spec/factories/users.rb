# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Test User' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password_digest { 'MyString' }
  end
end
