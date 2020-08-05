# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    project_name { 'PJ_Factory' }
    status { :in_progress }
    description { 'factory_test' }
    started_at { Time.zone.today }
    finished_at { Time.zone.today }
  end
end
