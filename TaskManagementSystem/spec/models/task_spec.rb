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

  describe 'SarchingTask' do
    3.times do |n|
      let!(:valid_task) {create(:valid_sample_task, status: n, title: "タスクの名前#{n}")}
    end
    # ステータスの検索ができる
    it 'can search task by status' do 
      @tasks = Task.sort('old').where("status LIKE ?", "%1%")
      @tasks.each do |task|
        expect(task.status).to eq 1
      end
    end
    # タスク名の検索ができる
    it 'can search task by title' do 
      @tasks = Task.sort('old').where("title LIKE ?", "%タスクの名前1%")
      @tasks.each do |task|
        expect(task.title).to eq "タスクの名前1"
      end
    end
  end
end
