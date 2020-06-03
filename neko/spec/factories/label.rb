FactoryBot.define do
  factory :label, class: Label do
    sequence(:name) { Faker::Music }
  end
end
