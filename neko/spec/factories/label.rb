FactoryBot.define do
  factory :label, class: Label do
    sequence(:name, 'label1')
  end
end
