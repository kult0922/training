# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    association :user
    sequence(:name, 'test_label_1')
  end
end
