FactoryBot.define do
  factory :task, class: Task do
    name { 'task' }
    description { 'first task' }
    end_date { '2021-06-24' }
    status { 'todo' }
    priority { 1 }
  end

  factory :private_task, class: Task do
    name { 'private_task' }
    description { 'this is private task' }
    end_date { (Time.zone.today + 10.days).to_s }
    priority { 1 }
  end

  factory :work_task, class: Task do
    name { 'work_task' }
    description { 'this is work task' }
    end_date { (Time.zone.today + 5.days).to_s }
    priority { 5 }
  end

  factory :emergency_task, class: Task do
    name { 'emergency_task' }
    description { 'this is emergency task' }
    end_date { Time.zone.today.to_s }
    priority { 10 }
  end
end
