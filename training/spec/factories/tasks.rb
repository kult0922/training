FactoryBot.define do
  factory :task do
    title { 'task title' }
    description { 'task description' }
    priority { 'low' }
    status { 'waiting' }
    due_date { '2019-04-14' }
  end
end
