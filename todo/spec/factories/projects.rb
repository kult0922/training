# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:project_name) { 'PJ_Factory' }
    sequence(:status) { :in_progress }
    sequence(:description) { 'factory_test' }
    sequence(:started_at) { Time.zone.today }
    sequence(:finished_at) { Time.zone.today }
  end
end
