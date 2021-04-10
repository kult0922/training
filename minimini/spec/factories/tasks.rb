FactoryBot.define do
    factory :task do
        id           {"1"}
        name         {"タスク名1"}
        description  {"タスク内容1"}
        status       {"未着手"}
        labels       {"1"}
        user_id      {"9999"}
        due_date     {"2022-01-01"}
    end
end
