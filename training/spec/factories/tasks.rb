FactoryBot.define do
  factory :task do
    title { 'task title' }
    description { 'task description' }
    priority { 'low' }
    status { 'waiting' }
    due_date { '2019-04-14' }

    trait :with_order_by_created_at do
      now = Time.now
      sequence(:title) { |n| "task title-#{n}" }
      sequence(:created_at) { |n| now - n.days }
    end
  end
end
