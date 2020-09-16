# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'POST /tasks/:id' do
    subject(:action) do
      login_request_as(user)
      post tasks_path, params: params
      response
    end

    let(:user) { create(:user) }

    let(:params) {
      {
        task: {
          title: 'test1',
          description: 'test1',
          due_date: Date.parse('2020-04-01'), # Any date
          status: 'doing', # Non-default value
          user_id: user.id,
        },
      }
    }

    context 'when valid params' do
      it 'task is saved' do
        expect(Task.count).to eq 0
        action

        expect(Task.count).to eq 1
        expect(flash[:notice]).to eq 'タスクを作成しました'
      end
    end

    context 'when title is nil' do
      let(:params) { super().merge(task: { title: nil }) }

      it 'task is not saved' do
        expect(Task.count).to eq 0
        action

        expect(Task.count).to eq 0
      end
    end
  end

  describe 'PATCH /task/:id' do
    subject(:action) do
      login_request_as(user)
      patch "/tasks/#{task.id}", params: params
      response
    end

    let(:params) {
      {
        task: {
          title: 'after_title',
          description: 'after_description',
          user_id: user.id,
        },
      }
    }

    let(:user) { create(:user) }
    let(:task) { create(:task) }

    before do
      task.update(
        title: 'before_title',
        description: 'before_description',
      )
    end

    context 'when valid params' do
      it 'to be updated' do
        action

        task.reload
        is_expected.to have_http_status(:found)

        expect(task.title).to eq 'after_title'
        expect(task.description).to eq 'after_description'
      end
    end

    context 'when title is nil' do
      let(:params) { super().merge(task: { title: nil }) }
      it 'not updated' do
        action
        task.reload

        expect(task.title).to eq 'before_title'
      end
    end

    context 'when description dont update' do
      let(:params) { super().merge(task: { title: 'after_title' }) }

      it 'task.title has been updated with after_title' do
        action

        task.reload
        is_expected.to have_http_status(:found)

        expect(task.title).to eq 'after_title'
        expect(task.description).to eq 'before_description'
        expect(flash[:notice]).to eq 'タスクを編集しました'
      end
    end

    context 'when title dont update' do
      let(:params) { super().merge(task: { description: 'after_description' }) }

      it 'task.description has been updated with after_description' do
        action

        task.reload
        is_expected.to have_http_status(:found)

        expect(task.title).to eq 'before_title'
        expect(task.description).to eq 'after_description'
      end
    end

    context 'when description is nil' do
      let(:params) { super().merge(task: { title: 'after_title', description: nil }) }

      it 'task.description has been updated with nil' do
        action

        task.reload
        is_expected.to have_http_status(:found)

        expect(task.title).to eq 'after_title'
        expect(task.description).to eq nil
      end
    end
  end

  describe 'DELETE /task/:id' do
    subject(:action) do
      login_request_as(user)
      delete "/tasks/#{task_1.id}", params: {}
      response
    end

    let(:user) { create(:user) }
    let!(:task_1) { create(:task, user: user) }
    let!(:task_2) { create(:task, user: user) }

    it 'status is 302' do
      action

      is_expected.to have_http_status(:found)
      expect(flash[:notice]).to eq 'タスクを削除しました'
    end

    it 'task can be deleted' do
      expect { action }.to change { Task.count }.from(2).to(1)
    end
  end
end
