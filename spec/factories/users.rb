# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Test User' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'Ab12345+' }
    password_confirmation { 'Ab12345+' }
  end
end
