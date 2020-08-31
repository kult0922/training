# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :account_name do |n|
      "factoryUser#{n}"
    end
    password { 'testtest' }
    password_confirmation { 'testtest' }
  end
end
