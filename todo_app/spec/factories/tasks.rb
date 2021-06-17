FactoryBot.define do
  sequence :task_title do |i|
    "タイトル #{i}"
  end

  factory :task, class: Task do
    title { generate :task_title }
    description { '説明' }
  end

  factory :past_task, class: Task do
    title { generate :task_title }
    description { '説明' }
    created_at { Time.current.yesterday }
  end
end
