FactoryBot.define do
    factory :test_user, class: User do
        name { "test user" }
        email { "test@test.com" }
        password { "examplePASSWORD12345" }
    end
    factory :invalid_user
end
