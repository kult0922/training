FactoryBot.define do
  factory :label do
    name { 'label' }
    deleted_at { nil }
    association :user
  end
end
