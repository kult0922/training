FactoryBot.define do
  factory :user, class: User do
    sequence(:name, 'user_1')
  end
end
