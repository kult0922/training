# frozen_string_literal: true

FactoryBot.define do
  factory :authority do
    sequence(:role, 1)
    sequence(:name, 'test_role_1')
  end
end
