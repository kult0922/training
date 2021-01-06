# frozen_string_literal: true

FactoryBot.define do
  factory :task_label_relation do
    task_id { create(:task).id }
    label_id { create(:label).id }
  end
end
