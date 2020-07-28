# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'タスク名' }
    status { Task.statuses[:open] }
    due_date { Time.current.tomorrow }
  end
end
