require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let!(:task) { create(:task) }

  describe '#task index' do
    context 'GET' do
      example 'request OK' do
        get root_path
        expect(response.status).to eq(200)
      end
    end
  end

  describe '#task new' do
    context 'GET' do
      example 'request OK' do
        get new_task_path
        expect(response.status).to eq(200)
      end
    end
    context 'POST' do
      example 'request OK' do
        post tasks_path, params: { task: attributes_for(:task) }
        expect(response.status).to eq(302)
      end
      example 'create task' do
        expect do
          post tasks_path, params: { task: attributes_for(:task) }
        end.to change{ Task.count }.by(1)
      end
    end
  end

  describe '#task edit' do

    context 'GET' do
      example 'request OK' do
        get edit_task_path(task)
        expect(response.status).to eq(200)
      end
    end
    context 'PATCH' do
      example 'request OK' do
        patch task_path(task), params: { id: task.id, task: attributes_for(:task, title: "sample") }
        expect(response.status).to eq(302)
      end
      example 'update OK' do
        expect do
          patch task_path(task), params: { id: task.id, task: attributes_for(:task, title: "sample") }
        end.to change{ Task.find(task.id).title }.from('title').to('sample')
      end
    end
  end

  describe '#task delete' do
    context 'DESTROY' do
      example 'request OK' do
        delete task_path(task), params: { id: task.id }
        expect(response.status).to eq(302)
      end
      example 'delete OK' do
        expect do
          delete task_path(task), params: { id: task.id }
        end.to change{ Task.count }.by(-1)
      end
    end
  end
end
