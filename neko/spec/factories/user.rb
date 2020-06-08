FactoryBot.define do
  factory :user, class: User do
    sequence(:name, 'user1')
  end
end
