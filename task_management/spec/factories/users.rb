# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    association :authority
    sequence(:login_id, 'user_1')
    sequence(:name, 'name_1')
    sequence(:password, 'pass_1')
  end
end
