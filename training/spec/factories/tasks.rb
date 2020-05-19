FactoryBot.define do
  factory :task do
    title { 'title' }
    description { 'description' }
    priority { 'low' }
    status { 'waiting' }
    due_date { '2019-04-14' }
  end
end
