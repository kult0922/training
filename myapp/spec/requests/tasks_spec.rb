# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'POST /tasks/:id' do
    subject(:action) do
      post tasks_path, params: params
      response
    end

    let(:params) {
      {
        task: {
          title: 'test1',
          discription: 'test1',
        },
      }
    }

    context 'when valid params' do
      it 'task is saved' do
        action

        is_expected.to have_http_status(:found)

        expect(Task.count).to eq 1
        expect(flash[:notice]).to eq 'Added task'
      end
    end

    context 'when title is nil' do
      let(:params) { super().merge(task: { title: nil }) }

      it 'task is not saved' do
        action

        is_expected.to have_http_status(:found)

        expect(Task.count).to eq 0
        expect(flash[:notice]).to eq 'Failure added task'
      end
    end

    describe 'PATCH /task/:id' do
      subject(:action) do
        patch "/tasks/#{task.id}", params: params
        response
      end

      let(:params) {
        {
          task: {
            title: 'after_title',
            discription: 'after_discription',
          },
        }
      }

      let(:task) { create(:task) }

      before do
        task.update(
          title: 'before_title',
          discription: 'before_discription',
        )
      end

      context 'when valid params' do
        it 'to be updated' do
          action

          task.reload
          is_expected.to have_http_status(:found)

          expect(task.title).to eq 'after_title'
          expect(task.discription).to eq 'after_discription'
        end
      end

      context 'when title is nil' do
        let(:params) { super().merge(task: { title: nil }) }

        it 'not updated' do
          action

          task.reload
          is_expected.to have_http_status(:found)

          expect(task.title).to eq 'before_title'
          expect(flash[:notice]).to eq 'Failure edited task'
        end
      end

      context 'when discription dont update' do
        let(:params) { super().merge(task: { title: 'after_title' }) }

        it 'task.title has been updated with after_title' do
          action

          task.reload
          is_expected.to have_http_status(:found)

          expect(task.title).to eq 'after_title'
          expect(task.discription).to eq 'before_discription'
        end
      end

      context 'when title dont update' do
        let(:params) { super().merge(task: { discription: 'after_discription' }) }

        it 'task.description has been updated with after_discription' do
          action

          task.reload
          is_expected.to have_http_status(:found)

          expect(task.title).to eq 'before_title'
          expect(task.discription).to eq 'after_discription'
        end
      end

      context 'when discription is nil' do
        let(:params) { super().merge(task: { title: 'after_title', discription: nil }) }

        it 'task.description has been updated with nil' do
          action

          task.reload
          is_expected.to have_http_status(:found)

          expect(task.title).to eq 'after_title'
          expect(task.discription).to eq nil
        end
      end
    end

    describe 'DELETE /task/:id' do
      subject(:action) do
        delete "/tasks/#{task_1.id}", params: {}
        response
      end

      let!(:task_1) { create(:task) }
      let!(:task_2) { create(:task) }

      it 'status is 302' do
        action

        is_expected.to have_http_status(:found)
        expect(flash[:notice]).to eq 'Deleted task'
      end

      it 'task can be deleted' do
        expect { action }.to change { Task.count }.from(2).to(1)
      end
    end
  end
end
