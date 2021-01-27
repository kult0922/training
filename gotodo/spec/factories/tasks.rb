# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |i|
    "タスク#{format('%02d', i)}"
  end

  sequence :end_date do |i|
    Time.current + (i + 1).days
  end

  factory :task, class: Task do
    title { generate :title }
    detail { 'テスト' }
    end_date { generate :end_date }
    status { 'doing' }
    user
  end
end
