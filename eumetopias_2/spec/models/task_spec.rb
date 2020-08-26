require 'rails_helper'

RSpec.describe Task, type: :model do
  before do 
    statuses = {"未着手"=>"誰も手を付けていない", "着手中"=>"対応中", "完了"=>"対応完了"}
    statuses.each do |key, value| 
      TaskStatus.create(name: key, description: value)
    end
  end

  it 'is invalid without title and description' do
    new_task = Task.new()
    new_task.valid?
    expect(new_task.errors.messages[:title]).to include('を入力してください')
    expect(new_task.errors.messages[:description]).to include('を入力してください')
  end

  it 'search_by_status_id shoud match correct records count' do
    untouch_id = TaskStatus.find_by(name: '未着手').id
    in_progress_id = TaskStatus.find_by(name: '着手中').id
    finished_id = TaskStatus.find_by(name: '完了').id
    sample_ids = [untouch_id]
    2.times {sample_ids.push(in_progress_id)}
    3.times {sample_ids.push(finished_id)}
    sample_ids.each do |status_id|
      Task.create(title: "test title", description: "test description", task_status_id: status_id)
    end
    expect(Task.search_by_status_id(untouch_id).count).to eq 1
    expect(Task.search_by_status_id(in_progress_id).count).to eq 2
    expect(Task.search_by_status_id(finished_id).count).to eq 3
  end
end
