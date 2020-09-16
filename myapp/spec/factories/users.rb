FactoryBot.define do
  factory :user do
    name { Faker::Superhero.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
