FactoryBot.define do
  factory :user do
    name { Faker::Movies::StarWars.character }
    email { Faker::Internet.email }
    password { 'password' }
    is_admin { true }
  end
end
