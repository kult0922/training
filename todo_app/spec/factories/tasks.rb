FactoryBot.define do
  factory :task, class: Task do
    title { 'タイトル' }
    description { '説明' }
  end

  factory :past_task, class: Task do
    title { 'タイトル' }
    description { '説明' }
    created_at { Time.current.yesterday }
  end
end
