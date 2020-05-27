FactoryBot.define do
  factory :task do
    title { 'task title' }
    description { 'task description' }
    priority { 'low' }
    status { 'waiting' }
    due_date { Time.now + 1.day }

    trait :with_order_by_created_at do
      now = Time.now
      sequence(:created_at) { |n| now - n.days }
    end
  end
end
