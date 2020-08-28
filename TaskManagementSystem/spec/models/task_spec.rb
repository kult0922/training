require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'ValidationRunsWhenCreatingTasks' do
    let(:valid_task) { build(:valid_sample_task) }
    let(:invalid_task) {build(:valid_sample_task, user_id: nil, title: 'タスク名の編集テスト'*20, description: 'タスク説明の編集テスト'*100, priority: nil, deadline: Time.strptime("2019年10月2日 12:13:23", '%Y年%m月%d日 %H:%M:%S'), status: nil)}
    # validationを通過する
    it 'is valid when creating new task' do
      expect(valid_task).to be_valid
    end
    # エラーの表示がされている
    it 'is invalid when creating new task' do
      expect(invalid_task).not_to be_valid
    end
  end
end
