require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:task_status_untouch) { create(:untouch) }
  let!(:task_status_in_progress) { create(:in_progress) }
  let!(:task_status_finished) { create(:finished) }

  before do
    @untouch_id = task_status_untouch.id
    @in_progress_id = task_status_in_progress.id
    @finished_id = task_status_finished.id
    sample_status_ids = [@untouch_id]
    2.times {sample_status_ids.push(@in_progress_id)}
    3.times {sample_status_ids.push(@finished_id)}
    sample_status_ids.each do |status_id|
      Task.create(title: "test title", description: "test description", task_status_id: status_id)
    end
  end

  it 'is invalid without title and description' do
    new_task = Task.new()
    new_task.valid?
    expect(new_task.errors.messages[:title]).to include('を入力してください')
    expect(new_task.errors.messages[:description]).to include('を入力してください')
  end

  it 'search_by_status_id shoud match correct records count' do
    expect(Task.search_by_status_id(@untouch_id).count).to eq 1
    expect(Task.search_by_status_id(@in_progress_id).count).to eq 2
    expect(Task.search_by_status_id(@finished_id).count).to eq 3
  end
end
