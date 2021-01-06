# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    user_id { create(:user).id }
    sequence(:name, 'test_label_1')
  end
end
