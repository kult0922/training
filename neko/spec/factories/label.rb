FactoryBot.define do
  factory :label, class: Label do
    sequence(:name, 'label_1')

    association :user
  end
end
