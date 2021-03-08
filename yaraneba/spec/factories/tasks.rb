FactoryBot.define do
  factory :task do
    title { 'title' }
    detail { 'detail' }
    priority { '1' }
    status { 'completed' }
    end_date { Date.tomorrow.strftime('%Y-%m-%d') }
    deleted_at { nil }
    sequence(:created_at) { |n| Time.zone.now.since(n.day) }
  end
end
