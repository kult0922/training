FactoryBot.define do
  factory :task_template, class: Task do
    name {'test_name'}
    description {'test_description'}
  end
end