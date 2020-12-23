# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:status) {|n| 10*((n % 3)+1) }
    sequence(:title) { |n| "TEST_TITLE#{n}" }
    sequence(:detail) { |n| "TEST_DETAIL#{n}" }
    sequence(:end_date) { |n| Time.zone.now + 1000.days - n.days }
  end
end
