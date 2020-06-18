FactoryBot.define do
  factory :auth, class: AuthInfo do
    email { 'test@example.com' }
    password { 'testpassword' }

    association :user
  end
end
