FactoryBot.define do
  factory :task do
    name {'my task'}
    description {'this is my task'}
    end_date {'2021-06-24'}
    priority {1}
  end
end
