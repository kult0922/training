FactoryBot.define do
  factory :task, class: Task do
    name { 'task' }
    description { 'first task' }
    end_date { '2021-06-24' }
    status { 'todo' }
    priority { 1 }

    trait :private do
      end_date { (Time.zone.today + 10.days).to_s }
      priority { 1 }
    end

    trait :work do
      end_date { (Time.zone.today + 5.days).to_s }
      priority { 5 }
    end

    trait :emergency do
      end_date { Time.zone.today.to_s }
      priority { 10 }
    end
  end
end
