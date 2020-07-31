# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :account_name do |n|
      "user_#{n}"
    end
    sequence(:password) { 'test' }
  end
end
