FactoryBot.define do
  factory :task do
    user_id { create(:user).id }
    sequence(:name) { 'test_task_1' }
    sequence(:details) { 'test_detail_1' }
    deadline { Time.now + 3.days }
    status { 1 }
    priority { 1 }
    creation_date { Time.now }
  end
end
