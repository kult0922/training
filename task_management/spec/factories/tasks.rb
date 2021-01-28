# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'test_task_1' }
    details { 'test_details_1' }
    deadline { Time.zone.now + 10.days }
    status { 1 }
    priority { 1 }
    creation_date { Time.zone.now + 5.days }
  end
end
