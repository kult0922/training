# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user_id: user.id) }

  describe '#task logging in' do
    before do
      post login_path, params: { email: 'yu.oikawa@rakuten.com', password: '12345' }
    end

    describe 'index' do
      context 'GET' do
        example 'request OK' do
          get tasks_path
          expect(response).to have_http_status :ok
        end
      end
    end

    describe 'new' do
      context 'GET' do
        example 'request OK' do
          get new_task_path
          expect(response).to have_http_status :ok
        end
      end
      context 'POST' do
        example 'request OK' do
          post tasks_path, params: { task: attributes_for(:task) }
          expect(response).to have_http_status :redirect
        end
        example 'create task' do
          expect do
            post tasks_path, params: { task: attributes_for(:task) }
          end.to change { Task.count }.by(1)
        end
      end
    end

    describe 'edit' do
      context 'GET' do
        example 'request OK' do
          get edit_task_path(task)
          expect(response).to have_http_status :ok
        end
      end
      context 'PATCH' do
        example 'request OK' do
          patch task_path(task), params: { id: task.id, task: attributes_for(:task, title: 'sample') }
          expect(response).to have_http_status :redirect
        end
        example 'update OK' do
          expect do
            patch task_path(task), params: { id: task.id, task: attributes_for(:task, detail: 'sample') }
          end.to change { Task.find(task.id).detail }.from('detail').to('sample')
        end
      end
    end

    describe 'delete' do
      context 'DESTROY' do
        example 'request OK' do
          delete task_path(task), params: { id: task.id }
          expect(response).to have_http_status :redirect
        end
        example 'delete OK' do
          expect do
            delete task_path(task), params: { id: task.id }
          end.to change { Task.count }.by(-1)
        end
      end
    end

    describe 'not allowed user' do
      context 'edit' do
        example 'redirect task page' do
          new_task = create(:task)
          patch task_path(new_task), params: { title: 'new' }
          expect(response).to redirect_to('/tasks')
        end
      end
    end
  end

  describe '#task not logged in' do
    context 'new' do
      example 'reidrect login page' do
        get new_task_path
        expect(response).to redirect_to('/login')
      end
    end

    context 'edit' do
      example 'redirect login page' do
        get edit_task_path(task)
        expect(response).to redirect_to('/login')
      end
    end
  end
end
