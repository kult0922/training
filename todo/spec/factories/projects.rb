# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:project_name) {'PJ_Factory'}
    sequence(:status) {'0'}
    sequence(:description) {'factory_test'}
    sequence(:started_at) {Date.today}
    sequence(:finished_at) {Date.today}
  end
end
