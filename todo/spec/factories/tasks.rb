# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:task_name) {'test_task'}
    sequence(:project_id) {Project.first.id}
    sequence(:priority) {'2'}
    sequence(:assignee_id) {'1'}
    sequence(:reporter_id) {'1'}
    sequence(:description) {'test_discription'}
    sequence(:started_at) {Date.today}
    sequence(:finished_at) {Date.today}
  end
end
