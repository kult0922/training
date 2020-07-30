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
  end
end
