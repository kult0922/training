# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    status { 10 }
    sequence(:title) { |n| "TEST_TITLE#{n}" }
    sequence(:detail) { |n| "TEST_DETAIL#{n}" }
    sequence(:end_date) { |n| Time.zone.now + 1000.days - n.days }
  end
end
