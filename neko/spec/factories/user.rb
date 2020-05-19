FactoryBot.define do
  factory :user, class: User do
    sequence(:name) { Faker::Name.name }
  end
end
