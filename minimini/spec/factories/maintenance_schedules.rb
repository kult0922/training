FactoryBot.define do
  factory :maintenance_schedule do
    id         { 1000 }
    reason     { "進行中-定期メンテナンス" }
    start_time { Time.zone.now.ago(30.minutes) }
    end_time   { Time.zone.now.since(10.minutes) }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }

    trait :maintenance_schedule_over do
      end_time   { Time.zone.now.ago(1.minutes) }
    end
  end
end
