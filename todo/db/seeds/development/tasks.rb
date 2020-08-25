# frozen_string_literal: true

50.times do |n|
  Task.create!(
    task_name: "seed task_#{n}",
    project_id: Project.first.id,
    status: :todo,
    priority: :low,
    description: 'factory_test',
    assignee_id: User.first.id,
    reporter_id: User.first.id,
    started_at: Time.zone.today,
    finished_at: Time.zone.today
  )
end
