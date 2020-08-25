FactoryBot.define do
  # 異なる作成日を生成
  sequence :sample_created do |i|
    Time.strptime("2020年9月#{i}日 12:13:23", '%Y年%m月%d日 %H:%M:%S')
  end

  factory :sample_task, class: Task do
    user_id {1}
    title {'タスク名の編集テスト'}
    description {'タスク説明の編集テスト'}
    priority {1}
    deadline {Time.strptime("2020年10月2日 12:13:23", '%Y年%m月%d日 %H:%M:%S')}
    status {1}
    created_at {generate :sample_created}
  end
end
