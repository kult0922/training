FactoryBot.define do
  factory :task do
    name { 'test1' }
    description { 'test1_description' }
    end_date { Time.now + 3.days }
    priority { :low }
    status { :todo }
  end
end
