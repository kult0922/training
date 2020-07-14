FactoryBot.define do
  factory :user do
    name { 'test_user' }
    sequence(:mail_address) { |n| "test#{n}@example.com" }
    password { 'password' }
  end
end
