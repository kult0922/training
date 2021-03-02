FactoryBot.define do
  factory :task do
    title { 'title'}
    detail { 'detail' }
    priority { '1' }
    status { '1' }
    end_date { Date.yesterday }
    deleted_at { nil }
  end
end
