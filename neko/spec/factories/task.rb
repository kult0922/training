FactoryBot.define do
  factory :task, class: Task do
    sequence(:name, 'task_1')
    sequence(:description, 'this is task_1')
    sequence(:due_at) { Faker::Time.forward(days: 300) }
    sequence(:have_a_due) { Faker::Boolean.boolean }
    sequence(:status) { Task.statuses.values.sample }

    association :user
  end
end
