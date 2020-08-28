FactoryBot.define do
  # 異なる作成日を生成
  sequence :sample_user_id do |i|
    i
  end

  sequence :sample_created do |i|
    Time.strptime("2020年9月#{i}日 12:13:23", '%Y年%m月%d日 %H:%M:%S')
  end

  sequence :sample_deadline do |i|
    Time.strptime("2020年10月#{i}日 12:13:23", '%Y年%m月%d日 %H:%M:%S')
  end


  factory :valid_sample_task, class: Task do
    user_id {generate :sample_user_id}
    title {'タスク名の編集テスト'}
    description {'タスク説明の編集テスト'}
    priority {1}
    deadline {generate :sample_deadline}
    status {1}
    created_at {generate :sample_created}
  end
end
