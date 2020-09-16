FactoryBot.define do
    factory :test_user, class: User do
        name { "test user" }
        email { "test@test.com" }
        password { "examplePASSWORD12345" }
    end
    factory :test_user2, class: User do
        name { "test user 2" }
        email { "test_2@test.com" }
        password { "examplePASSWORD12345" }
    end

end
