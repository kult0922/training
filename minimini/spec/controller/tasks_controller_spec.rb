require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:each) do
    @task = create(:task)
    session[:current_user_id] = @task.user.id
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
    expect(Task.count).to eq 1
    post :create, params: {
        task: {
          name: "NEW タスク名1",
          description: "NEW タスク内容1",
          status: "not_started",
          labels: "very_important",
          user_id: "9999",
          due_date: "2022-01-01"
        }
      }
    expect(Task.count).to eq 2
    expect(response.status).to eq 302
  end

  it 'fail to create new task' do
    # name, descriptionがnil
    expect(Task.count).to eq 1
    post :create, params: {
        task: {
          status: "not_started",
          labels: "very_important",
          user_id: "9999",
          due_date: "2022-01-01"
        }
      }
    expect(Task.count).to eq 1
    expect(response.status).to eq 200
  end

  it 'render the show task page' do
    get :show, params: { id: @task[:id] }
    expect(response.status).to eq 200
  end

  it 'record not found error show 404' do
    get :show, params: { id: "99999999" }
    expect(response.status).to eq 404
  end

  it 'render the edit task page' do
    get :edit, params: { id: @task[:id] }
    expect(response).to render_template(:edit)
  end

  it 'update the task' do
    patch :update, params: {
      id: "10000",
      task: {
        id: "10000",
        name: "[updated]タスク名1",
        description: "[updated]タスク内容1",
        status: "completed",
        labels: "normal",
        due_date: "2023-01-01"
      }
    }
    expect(response.status).to eq 302
  end

  it 'delete one task' do
    expect(Task.count).to eq 1
    delete :destroy, params: { id: @task[:id] }
    expect(Task.count).to eq 0
    expect(response.status).to eq 302
  end

  it 'fail to delete one task' do
    expect(Task.count).to eq 1
    delete :destroy, params: { id: "99999999"}
    expect(Task.count).to eq 1
    expect(response.status).to eq 404
  end

  it 'search with not_started status' do
    get :index, params: {
        search: {
          status: "not_started",
          sort_order: "ASC"
        }
      }

    expect(response).to render_template(:index)
  end
end
