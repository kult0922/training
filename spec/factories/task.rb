# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    status { 10 }
    sequence(:title) { |n| "TEST_TITLE#{n}" }
    sequence(:detail) { |n| "TEST_DETAIL#{n}" }
    end_date { '2020/12/2' }
  end
end
