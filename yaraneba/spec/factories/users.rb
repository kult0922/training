FactoryBot.define do
  factory :user do
    sequence(:email) { |n| 'yu.oikawa@rakuten.com' + n.to_s }
    password { '12345' }
  end
end
