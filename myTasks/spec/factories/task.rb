FactoryBot.define do
  factory :task1, class: Task do
    name { 'task1' }
    description { 'first task' }
    end_date { '2021-06-24' }
    priority { 1 }
  end

  factory :task2, class: Task do
    name { 'task2' }
    description { 'second task' }
    end_date { '2021-06-25' }
    priority { 1 }
  end

  factory :task3, class: Task do
    name { 'task3' }
    description { 'third task' }
    end_date { '2021-06-26' }
    priority { 1 }
  end
end
