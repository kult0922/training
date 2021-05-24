# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'タスク1' }
    description { 'xxxを提出する' }
    priority { 1 }
  end
end
