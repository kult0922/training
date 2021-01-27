# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    name { '太郎' }
    email { 'test@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    role
  end
end
