require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'new' do
    context 'logging in' do
      let!(:user) { create(:user, role_id: 'member') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'redirect main page' do
        get new_user_path
        expect(response).to redirect_to('/tasks')
      end
    end

    context 'not logged in' do
      example 'response OK' do
        get new_user_path
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'update' do
    context 'logging in member' do
      let!(:user) { create(:user, role_id: 'member') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response 404' do
        patch user_path(user), params: { user: attributes_for(:user, email: 'sample') }
        expect(response).to have_http_status :not_found
      end
    end

    context 'logging in admin' do
      let!(:user) { create(:user, role_id: 'admin') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'user update successfully' do
        patch user_path(user), params: { user: attributes_for(:user, email: 'sample') }
        expect(User.find(user.id).email).to eq('sample')
      end
    end

    context 'not logged in' do
      let!(:user) { create(:user, role_id: 'admin') }
      example 'response 404' do
        patch user_path(user), params: { user: attributes_for(:user, email: 'sample') }
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'create' do
    context 'logging in' do
      let!(:user) { create(:user, role_id: 'member') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'redirect task page' do
        post users_path, params: { user: { email: 'sample@rakuten.com', password: 'sample' } }
        expect(response).to redirect_to('/tasks')
      end
    end

    context 'not logged in' do
      example 'redirect login page' do
        expect do
          post users_path, params: { user: { email: 'sample@rakuten.com', password: 'sample' } }
        end.to change { User.count }.by(1)
      end
    end
  end

  describe 'destroy' do
    context 'logging in member' do
      let!(:user) { create(:user, role_id: 'member') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response 404' do
        member_user = create(:user, role_id: 'member')
        delete user_path(member_user), params: { id: member_user.id }
        expect(response).to have_http_status :not_found
      end
    end

    context 'logging in admin' do
      let!(:user) { create(:user, role_id: 'admin') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'users delete' do
        member_user = create(:user, role_id: 'member')
        expect do
          delete user_path(member_user), params: { id: member_user.id }
        end.to change { User.count }.by(-1)
      end
    end

    context 'not logged in' do
      example 'response 404' do
        member_user = create(:user, role_id: 'member')
        delete user_path(member_user), params: { id: member_user.id }
        expect(response).to have_http_status :not_found
      end
    end
  end
end
