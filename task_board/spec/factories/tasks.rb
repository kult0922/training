FactoryBot.define do
  factory :task do
    sequence(:name) { 'test1' }
    sequence(:description) { 'test1_description' }
    sequence(:end_date) { Time.now.next_week }
    sequence(:priority) { :底 }
    sequence(:status) { :未着手 }
  end
end
