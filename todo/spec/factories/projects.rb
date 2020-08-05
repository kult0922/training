# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    project_name { 'PJ_Factory' }
    status { :in_progress }
    description { 'factory_test' }
    started_at { Time.zone.local(2020, 8, 1) }
    finished_at { Time.zone.local(2020, 8, 5) }
  end
end
