# frozen_string_literal: true

project = FactoryBot.create(:project)

FactoryBot.define do
  factory :task do
    task_name { 'test_task' }
    project_id { project.id }
    priority { :high }
    description { 'test_discription' }
    started_at { Time.zone.today }
    finished_at { Time.zone.today }

    trait :order_by_created_at do
      sequence(:task_name) { |n| "task_#{n}" }
      sequence(:created_at) { |n| Time.zone.now + n.days }
    end
    
    trait :order_by_finished_at do
      sequence(:task_name) { |n| "task_#{n}" }
      sequence(:finished_at) { |n| Time.zone.now - n.days }
    end
  end
end
