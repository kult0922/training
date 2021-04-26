FactoryBot.define do
    factory :task do
        id           {"10000"}
        name         {"タスク名1"}
        description  {"タスク内容1"}
        status       {"completed"}
        labels       {"very_important"}
        user_id      {"9999"}
        due_date     {DateTime.now + 1.week}
        created_at   {DateTime.now}
        updated_at   {DateTime.now}

        user
    end
end
