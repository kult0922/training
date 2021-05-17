FactoryBot.define do
  factory :task1, class: Task do
    name {'test_task1'}
    description {'test_description1'}
  end

  factory :task2, class: Task do
    name {'test_task2'}
    description {'test_description2'}
  end

  factory :task_updated, class: Task do
    name {'test_task_updated'}
    description {'test_description_updated'}
  end
end