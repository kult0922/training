FactoryBot.define do
  factory :task, class: Task do
    name { 'task' }
    description { 'first task' }
    end_date { '2021-06-24' }
    priority { 1 }
  end
end
