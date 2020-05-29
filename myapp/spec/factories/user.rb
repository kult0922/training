FactoryBot.define do
  factory :user do
    name { 'Taro' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
    role { 0 }
  end
end
