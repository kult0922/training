FactoryBot.define do
  factory :task do
    title { Faker::Device.model_name }
    description { ["description1","description2"].sample }
    due_date { Faker::Date.forward(days: 1000) }
  end
end
