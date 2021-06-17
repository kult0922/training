require 'rails_helper'

describe TasksController, type: :controller do
  render_views

  before do
    @task = FactoryBot.create(:task)
  end

  it 'render the :index template' do
    get :index
    expect(response).to render_template :index
  end

  it 'Create new task' do
    expect(Task.count).to eq 1
    post :create, params: { task: { name: 'テストタスク', desc: 'just desc' } }
    expect(response.status).to eq 302
    expect(Task.count).to eq 2
  end

  #TODO : will do after adding validation to models
  # it 'Create new task fail' do
  # expect(Task.count).to eq 1
  # post :create, params: { task: { desc: 'just desc' } }
  # expect(response).to render_template :new
  # expect(Task.count).to eq 1
  # end

  it 'Display update screen' do
    get :show, params: { id: @task[:id] }
    expect(response.status).to eq 200
  end

  it 'Update task' do
    new_task_name = "#{@task[:name]} Edit"
    put :update, params: { id: @task[:id], task: { name: new_task_name } }
    expect(response.status).to eq 302
    expect(Task.find(@task.id).name).to eq new_task_name
  end

  it 'Update task not found' do
    put :update, params: { id: @task[:id] + 1, task: { name: "#{@task[:name]} Edit" } }
    expect(response.status).to eq 404
  end

  it 'Delete task' do
    expect(Task.count).to eq 1
    delete :destroy, params: { id: @task[:id] }
    expect(response.status).to eq 302
    expect(Task.count).to eq 0
  end

  it 'Sort by created_at desc' do
    @task1 = FactoryBot.create(:task, name: 'task1', created_at: Time.zone.tomorrow)
    @task2 = FactoryBot.create(:task, name: 'task2', created_at: Time.zone.yesterday)

    get :index
    expect(response.status).to eq 200

    res_str = response.body

    task1_index = res_str.index('task1')
    task2_index = res_str.index('task2')

    expect(task1_index).to be < task2_index
  end
end
