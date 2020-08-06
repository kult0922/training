Project.create!(
  task_name: "seed task",
  project_id: Project.first.id
  status: :todo,
  priority: :low,
  description: 'factory_test',
  assignee_id: User.first.id
  reporter_id: User.first.id
  started_at: Time.zone.today,
  finished_at: Time.zone.today
)