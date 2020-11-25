FactoryBot.define do
  factory :user do
    sequence(:name) { 'test_user_1' }
    sequence :email do |n|
      "test_user_#{n}@test.com"
    end
    password { 'password' }
    password_confirmation { 'password' }
    role { :admin }
  end
end
