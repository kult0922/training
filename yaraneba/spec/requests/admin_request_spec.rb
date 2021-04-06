require 'rails_helper'

RSpec.describe 'Admins', type: :request do
  describe 'user' do
    context 'not logged in' do
      example 'response 404' do
        get admin_users_path
        expect(response).to have_http_status :not_found
      end
    end

    context 'logging in member' do
      let!(:user) { create(:user, role_id: 'member') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response 404' do
        get admin_users_path
        expect(response).to have_http_status :not_found
      end
    end

    context 'logging in admin' do
      let!(:user) { create(:user, role_id: 'admin') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response ok' do
        get admin_users_path
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'task' do
    context 'not logged in' do
      example 'task list response 404' do
        get admin_tasks_path
        expect(response).to have_http_status :not_found
      end
    end

    context 'logging in member' do
      let!(:user) { create(:user, role_id: 'member') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response 404' do
        get admin_tasks_path
        expect(response).to have_http_status :not_found
      end
    end

    context 'logging in admin' do
      let!(:user) { create(:user, role_id: 'admin') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'task list response ok' do
        get admin_tasks_path
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'new' do
    context 'not logged in' do
      example 'response 404' do
        get admin_users_new_path
        expect(response).to have_http_status :not_found
      end
    end

    context 'logging in member' do
      let!(:user) { create(:user, role_id: 'member') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response 404' do
        get admin_users_new_path
        expect(response).to have_http_status :not_found
      end
    end

    context 'logging in admin' do
      let!(:user) { create(:user, role_id: 'admin') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response ok' do
        get admin_users_new_path
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'user_create' do
    context 'not logged in' do
      example 'response 404' do
        post admin_users_path, params: { user: attributes_for(:user, email: 'test', role_id: 'member') }
        expect(response).to have_http_status :not_found
      end
    end

    context 'logging in member' do
      let!(:user) { create(:user, role_id: 'member') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response 404' do
        post admin_users_path, params: { user: attributes_for(:user, email: 'test', role_id: 'member') }
        expect(response).to have_http_status :not_found
      end
    end

    context 'logging in admin' do
      let!(:user) { create(:user, role_id: 'admin') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'create success' do
        post admin_users_path, params: { user: attributes_for(:user, email: 'test', role_id: 'member') }
        expect(User.count).to eq(2)
      end
    end
  end
end
