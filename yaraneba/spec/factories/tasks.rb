FactoryBot.define do
  factory :task do
    title { 'title' }
    detail { 'detail' }
    priority { '1' }
    status { 'completed' }
    sequence(:end_date) { |n| Time.zone.now.since(n.day).strftime('%Y-%m-%d') }
    deleted_at { nil }
    sequence(:created_at) { |n| Time.zone.now.since(n.day) }
    association :user
  end
end
