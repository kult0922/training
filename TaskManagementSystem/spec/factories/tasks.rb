FactoryBot.define do
  factory :valid_sample_task, class: Task do
    sequence(:user_id){|i| i}
    sequence(:title){|i| "タスク名のテスト#{i}"}
    description {'タスク説明のテスト'}
    priority {1}
    sequence(:deadline){ |i| Time.strptime("2020年10月#{i}日 12:13:23", '%Y年%m月%d日 %H:%M:%S') }
    status {1}
    sequence(:created_at){ |i| Time.strptime("2020年9月#{i}日 12:13:23", '%Y年%m月%d日 %H:%M:%S') }
  end
end
