FactoryBot.define do
  factory :task do
     title { Faker::Alphanumeric.alphanumeric(number: 10) }
     description { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end