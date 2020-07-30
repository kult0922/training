# frozen_string_literal: true

project = FactoryBot.create(:project)

FactoryBot.define do
  factory :task do
    sequence(:task_name) {'test_task'}
    sequence(:project_id) {project.id}
    sequence(:priority) {:high}
    sequence(:description) {'test_discription'}
    sequence(:started_at) {Time.zone.today}
    sequence(:finished_at) {Time.zone.today}

    trait :order_by_created_at do
      sequence(:task_name) { |task| task += 1}
      sequence(:created_at) { |task| Time.zone.now - task.days }
    end
  end
end
