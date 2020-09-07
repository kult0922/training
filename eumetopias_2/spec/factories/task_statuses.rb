FactoryBot.define do
    factory :untouch, class: TaskStatus do
        name { "未着手" }
        description { "誰も手を付けていない" }
    end

    factory :in_progress, class: TaskStatus do
        name { "着手中" }
        description { "対応中" }
    end

    factory :finished, class: TaskStatus do
        name { "完了" }
        description { "対応完了" }
    end

    factory :task, class: Task do
        sequence(:title) {|n| "task_#{n}" }
        description { "sample description" }
        task_status_id { 1 }
    end
end
