# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    color { '#FF2D00' }
    sequence(:text, 'label_1')
  end
end
