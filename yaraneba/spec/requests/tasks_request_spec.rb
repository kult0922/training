# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let!(:user) { create(:user, role_id: 'member') }
  let!(:task) { create(:task, user_id: user.id) }

  describe 'index' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response OK' do
        get tasks_path
        expect(response).to have_http_status :ok
      end
    end

    context 'not logged in' do
      example 'reidrect login page' do
        get tasks_path
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'new' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response OK' do
        get new_task_path
        expect(response).to have_http_status :ok
      end
    end

    context 'not logged in' do
      example 'reidrect login page' do
        get new_task_path
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'edit' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response OK' do
        get edit_task_path(task)
        expect(response).to have_http_status :ok
      end
    end

    context 'not logged in' do
      example 'redirect login page' do
        get edit_task_path(task)
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'create' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response OK' do
        post tasks_path, params: { task: attributes_for(:task, label: '') }
        expect(response).to have_http_status :redirect
      end

      example 'task create successfully' do
        expect do
          post tasks_path, params: { task: attributes_for(:task, label: '') }
        end.to change { Task.count }.by(1)
      end

      example 'task with labels create successfully' do
        expect do
          post tasks_path, params: { task: attributes_for(:task, label: 'test label') }
        end.to change { Task.count }.by(1).
        and change { Label.count }.by(2).
        and change { LabelTask.count }.by(2)
      end
    end

    context 'not logged in' do
      example 'reidrect login page' do
        post tasks_path, params: { task: attributes_for(:task, label: '') }
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'update' do
    context 'loggin in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response OK' do
        patch task_path(task), params: { id: task.id, task: attributes_for(:task, title: 'sample', label: '') }
        expect(response).to have_http_status :redirect
      end

      example 'task update successfully' do
        expect do
          patch task_path(task), params: { id: task.id, task: attributes_for(:task, detail: 'sample', label: '') }
        end.to change { Task.find(task.id).detail }.from('detail').to('sample')
      end

      example 'task with label update successfully' do
        expect do
          patch task_path(task), params: { id: task.id, task: attributes_for(:task, detail: 'sample', label: 'test label') }
        end.to change { Task.find(task.id).detail }.from('detail').to('sample').
        and change { Label.count }.by(2).
        and change { LabelTask.count }.by(2)
      end

      context 'not allowed user' do
        example 'redirect /tasks' do
          new_task = create(:task)
          patch task_path(new_task), params: { title: 'new' }
          expect(response).to redirect_to('/tasks')
        end
      end
    end

    context 'not logged in' do
      example 'reidrect login page' do
        patch task_path(task), params: { id: task.id, task: attributes_for(:task, title: 'sample', label: '') }
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'destroy' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response OK' do
        delete task_path(task), params: { id: task.id }
        expect(response).to have_http_status :redirect
      end

      example 'task delete successfully' do
        expect do
          delete task_path(task), params: { id: task.id }
        end.to change { Task.count }.by(-1)
      end
    end

    context 'not logged in' do
      example 'reidrect login page' do
        delete task_path(task), params: { id: task.id }
        expect(response).to redirect_to('/login')
      end
    end
  end
end
