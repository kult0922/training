require 'rails_helper'

RSpec.describe Task, type: :model do
  before(:each) do
    @task = FactoryBot.create(:task)
  end

  it 'is valid with name, description, due_date' do
    expect(@task).to be_valid
  end

  it 'is invalid without a name' do
    @task.name = nil
    expect(@task).to be_invalid
    expect(@task.errors[:name]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a description' do
    @task.description = nil
    expect(@task).to be_invalid
    expect(@task.errors[:description]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a due_date' do
    @task.due_date = nil
    expect(@task).to be_invalid
    expect(@task.errors[:due_date]).to include(I18n.t('errors.messages.blank'))
  end

  it 'record found when search with default status and sort order' do
    user_search_params = SearchParam.new
    user_search_params.status = "#{Task.statuses[:not_selected]}"
    user_search_params.sort_order = "#{Task.sort_orders[:asc]}"

    tasks = Task.search(user_search_params, "9999")
    expect(tasks.size).to eq (1)
    expect(tasks).to include(@task)
  end

  it 'record found when search with "completed" status' do
    user_search_params = SearchParam.new
    user_search_params.status = "#{Task.statuses[:completed]}"
    user_search_params.sort_order = "#{Task.sort_orders[:asc]}"

    tasks = Task.search(user_search_params, "9999")
    expect(tasks.size).to eq (1)
    expect(tasks).to include(@task)
  end

  it 'record not found when search with "not started" status' do
    user_search_params = SearchParam.new
    user_search_params.status = "#{Task.statuses[:not_started]}"
    user_search_params.sort_order = "#{Task.sort_orders[:asc]}"

    tasks = Task.search(user_search_params, "9999")
    expect(tasks.size).to eq (0)
  end
end
