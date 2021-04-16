FactoryBot.define do
  factory :user do
      id         { "9999" }
      name       { "田中　美波" }
      email      { "trainee1@rakuten.com" }
      password_digest   { "$2a$12$i3nuuCjXLT7IyHFfl3IAm.dT.UZmXvz7Rza3yCyjcQRK/HuOI3VRy" }
      created_at {DateTime.now}
      updated_at {DateTime.now}
  end
end
