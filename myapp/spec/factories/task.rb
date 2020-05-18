FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "hogehoge#{n}" }
    memo { 'hugahuga' }
    deadline { Date.today.end_of_month }
    status { 'done'}
  end
end
