FactoryBot.define do
  factory :task do
    sequence(:name) { 'test_1' }
    sequence(description) { 'description_1' }
    end_date { Time.now + 3.days }
    priority { :low }
    status { :todo }
  end
end
