# frozen_string_literal: true

# 実行前にprojects seedが登録済みであること
FactoryBot.define do
  factory :task do
    sequence(:task_name) { 'test_task' }
    sequence(:project_id) { Project.first.id }
    sequence(:priority) { :high }
    sequence(:status) { :todo }
    sequence(:description) { 'test_discription' }
    sequence(:started_at) { Time.zone.today }
    sequence(:finished_at) { Time.zone.today }

    trait :order_by_created_at do
      sequence(:task_name) { |task| task + 1 }
      sequence(:created_at) { |task| Time.zone.now - task.days }
    end
    
    trait :order_by_finished_at do
      sequence(:task_name) { |task| task + 1 }
      sequence(:finished_at) { |task| Time.zone.now - task.days }
    end
  end
end
