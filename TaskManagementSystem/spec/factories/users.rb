FactoryBot.define do
  factory :login_user, class: User do
    last_name { 'ユーザー' }
    first_name { '太郎' }
    email { 'user_taro@sample.com' }
    password { 'password' }
    password_confirmation { 'password'}
  end

  factory :valid_sample_user, class: User do
    sequence(:last_name){|i| "ユーザー#{i}"}
    sequence(:first_name){|i| "太郎#{i}"}
    sequence(:email){|i| "user#{i}@sample.com"}
    sequence(:password){|i| "password#{i}"}
    sequence(:password_confirmation){|i| "password#{i}"}
  end
end
