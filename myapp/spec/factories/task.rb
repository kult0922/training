FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "t#{n}" }
    sequence(:description) { |n| "desc#{n}" }
  end
end
