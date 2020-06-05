require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe 'restrict_own_task' do
    let(:user) { FactoryBot.create(:user) }
    let(:task) { FactoryBot.create(:task, user: user) }

    context 'user who created task is same as login user' do
      before do
        post sessions_path, params: { email: user.email, password: user.password }
      end

      context 'edit' do
        it 'access edit page' do
          get edit_task_path(task)
          expect(response).to be_successful
        end
      end

      context 'show' do
        it 'access show page' do
          get task_path(task)
          expect(response).to be_successful
        end
      end

      context 'update' do
        it 'title updated' do
          put task_path(task), params: { task: { title: 'edit title' } }
          task.reload
          expect(task.title).to eq('edit title')
        end
      end

      context 'delete' do
        let!(:task) { FactoryBot.create(:task, user: user) }

        it 'delete 1 record' do
          expect {
            delete task_path(task)
          }.to change { Task.count }.by(-1)
        end
      end
    end

    context 'user who created task is different from login user' do
      before do
        post sessions_path, params: { email: user2.email, password: user2.password }
      end

      let(:user2) { FactoryBot.create(:user) }

      context 'edit' do
        it 'redirect to root path' do
          get edit_task_path(task)
          expect(response).to redirect_to(root_path)
        end
      end

      context 'show' do
        it 'redirect to root path' do
          get task_path(task)
          expect(response).to redirect_to(root_path)
        end
      end

      context 'update' do
        it 'title not updated' do
          put task_path(task), params: { task: { title: 'edit title' } }
          task.reload
          expect(task.title).not_to eq('edit title')
        end

        it 'redirect to root path' do
          put task_path(task), params: { task: { title: 'edit title' } }
          expect(response).to redirect_to(root_path)
        end
      end

      context 'delete' do
        let!(:task) { FactoryBot.create(:task, user: user) }

        it 'no record deleted' do
          expect {
            delete task_path(task)
          }.to change { Task.count }.by(0)
        end

        it 'redirect to root path' do
          delete task_path(task)
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end
