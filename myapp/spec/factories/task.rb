FactoryBot.define do
  factory :task do
    association :user
    sequence(:title) { |n| "t#{n}" }
    sequence(:description) { |n| "desc#{n}" }
  end
end
