# frozen_string_literal: true

FactoryBot.define do
  factory :role, class: Role do
    trait :admin do
      name { 'admin' }
      no { 0 }
    end

    trait :editor do
      name { 'editor' }
      no { 1 }
    end
  end
end
