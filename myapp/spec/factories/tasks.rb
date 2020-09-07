FactoryBot.define do
  factory :task do
    title { Faker::Device.model_name }
    description { ["description1","description2"].sample }
    due_date { Faker::Date.forward(days: 1000) }
    status { 'yet' } # default: 0
    user
  end
end
