# frozen_string_literal: true

FactoryBot.define do
  factory :user_credential do
    password_digest { 'Password' }
  end
end