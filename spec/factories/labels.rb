# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    name { 'Test Label' }
    user
  end
end
