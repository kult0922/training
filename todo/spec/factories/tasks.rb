# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:task_name) {'test_task'}
    sequence(:project_id) {Project.first.id}
    sequence(:priority) {:high}
    sequence(:assignee_id) {'1'}
    sequence(:reporter_id) {'1'}
    sequence(:description) {'test_discription'}
    sequence(:started_at) {Time.zone.today}
    sequence(:finished_at) {Time.zone.today}

    trait :order_by_created_at do
      sequence(:task_name) { |task| task += 1}
      sequence(:created_at) { |task| Time.zone.now - task.days }
    end
  end
end
