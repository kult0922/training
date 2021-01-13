# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:login_id, 'test_user_1')
    sequence(:name, 'test_name_1')
    sequence(:password, 'pass_1')
    authority_id { create(:authority).id }
  end
end
