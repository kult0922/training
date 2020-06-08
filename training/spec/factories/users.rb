FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "#{n}-#{Faker::Movies::StarWars.character}" }
    sequence(:email) {|n| "#{n}-#{Faker::Internet.email}" }
    password { 'password' }
    is_admin { true }
  end
end
