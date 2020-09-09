FactoryBot.define do
  factory :valid_sample_user, class: User do
    sequence(:last_name){|i| "ユーザー#{i}"}
    sequence(:first_name){|i| "太郎#{i}"}
    sequence(:email){|i| "user#{i}@sample.com"}
    sequence(:password){|i| "password#{i}"}
    sequence(:password_confirmation){|i| "password#{i}"}
  end
end
