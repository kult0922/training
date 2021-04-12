require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:each) do
    @task = create(:task)
  end

  it 'render the index page' do
    get :index
    expect(response).to render_template(:index)
  end

  it 'render the new task page' do
    get :new
    expect(response).to render_template(:new)
  end

  it 'create new task' do
    create_block = -> { post :create, params: {
        task: {
          name: "NEW タスク名1",
          description: "NEW タスク内容1",
          status: "未着手",
          labels: "1",
          user_id: "9999",
          due_date: "2022-01-01"
        }
      }
    }
    expect(create_block).to change { Task.count }.by(1)
    expect(response.status).to eq 302
  end

  it 'fail to create new task' do
    # name, descriptionがnil
    create_block = -> { post :create, params: {
        task: {
          status: "未着手",
          labels: "1",
          user_id: "9999",
          due_date: "2022-01-01"
        }
      }
    }
    expect(create_block).to change { Task.count }.by(0)
    expect(response.status).to eq 200
  end

  it 'render the show task page' do
    get :show, params: { id: @task[:id] }
    expect(response.status).to eq 200
  end

  it 'record not found error' do
    expect {
      get :show, params: { id: "99999999" }
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'render the edit task page' do
    get :edit, params: { id: @task[:id] }
    expect(response).to render_template(:edit)
  end

  it 'update the task' do
    patch :update, params: {
      id: "1",
      task: {
        id: "1",
        name: "[updated]タスク名1",
        description: "[updated]タスク内容1",
        status: "完了",
        labels: "D: 緊急度低",
        due_date: "2023-01-01"
      }
    }
    expect(response.status).to eq 302
  end

  it 'delete one task' do
    call_delete = ->  { delete :destroy, params: { id: @task[:id] } }
    expect(call_delete).to change { Task.count }.by(-1)
    expect(response.status).to eq 302
  end

  it 'fail to delete one task' do
    call_delete = ->  { delete :destroy, params: { id: "99999999"} }
    expect(call_delete).to raise_error(ActiveRecord::RecordNotFound)
  end
end
