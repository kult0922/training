# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    association :project
    task_name { 'test_task' }
    project_id { project.id }
    priority { :high }
    status { :done }
    description { 'test_discription' }
    started_at { Time.zone.local(2020, 8, 1) }
    finished_at { Time.zone.local(2020, 8, 5) }

    trait :order_by_created_at do
      sequence(:task_name) { |n| "task_#{n}" }
      sequence(:created_at) { |n| Time.zone.local(2020, 8, 1) + n.days }
    end
    
    trait :order_by_finished_at do
      sequence(:task_name) { |n| "task_#{n}" }
      sequence(:finished_at) { |n| Time.zone.local(2020, 8, 5) - n.days }
    end
  end
end
