require 'rails_helper'

RSpec.describe 'Admins', type: :request do
  describe '#admin not logged in' do
    context 'GET' do
      example 'user list request 404' do
        get admin_users_path
        expect(response).to have_http_status :not_found
      end

      example 'task list request 404' do
        get admin_tasks_path
        expect(response).to have_http_status :not_found
      end

      example 'task list request 404' do
        get admin_users_new_path
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe '#admin logging in' do
    describe 'member' do
      let!(:user) { create(:user, role_id: 'member') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      context 'GET' do
        example 'user list request 404' do
          get admin_users_path
          expect(response).to have_http_status :not_found
        end

        example 'task list request 404' do
          get admin_tasks_path
          expect(response).to have_http_status :not_found
        end

        example 'task list request 404' do
          get admin_users_new_path
          expect(response).to have_http_status :not_found
        end
      end
    end

    describe 'admin' do
      let!(:user) { create(:user, role_id: 'admin') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      context 'GET' do
        example 'user list request ok' do
          get admin_users_path
          expect(response).to have_http_status :ok
        end

        example 'task list request ok' do
          get admin_tasks_path
          expect(response).to have_http_status :ok
        end

        example 'users new request ok' do
          get admin_users_new_path
          expect(response).to have_http_status :ok
        end
      end

      context 'POST' do
        example 'users create' do
          post admin_users_path, params: { user: attributes_for(:user, email: 'test', role_id: 'member') }
          expect(User.count).to eq(2)
        end
      end
    end
  end
end
