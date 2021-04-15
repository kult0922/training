FactoryBot.define do
  factory :user do
      id         { "9999" }
      name       { "田中　美波" }
      email      { "trainee1@rakuten.com" }
      password_digest   { "password1" }
      created_at {DateTime.now}
      updated_at {DateTime.now}
  end
end