# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'testuser' }
    password { 'test' }
    password_confirmation { 'test' }
  end
end
