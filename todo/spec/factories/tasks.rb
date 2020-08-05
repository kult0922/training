# frozen_string_literal: true

project = FactoryBot.create(:project)

FactoryBot.define do
  factory :task do
    task_name { 'test_task' }
    project_id { project.id }
    priority { :high }
    description { 'test_discription' }
    started_at { Time.zone.local(2020, 8, 1) }
    finished_at { Time.zone.local(2020, 8, 5) }

    trait :order_by_created_at do
      sequence(:task_name) { |task| task + 1 }
      sequence(:created_at) { |task| Time.zone.local(2020, 8, 1) - task.days }
    end
  end
end
