FactoryBot.define do
  factory :task, class: Task do
    sequence(:title) {|n| "task_#{n}" }
    description { "sample description" }
    task_status_id { 1 }
  end
end
