require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#users not logged in' do
    context 'GET' do
      example 'request OK' do
        get new_user_path
        expect(response).to have_http_status :ok
      end
    end

    context 'POST' do
      example 'create users' do
        post users_path, params: { user: attributes_for(:user) }
        expect(User.count).to eq(1)
      end
    end
  end

  describe '#users logging in' do
    describe 'member' do
      let!(:user) { create(:user, role_id: 'member') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      context 'GET' do
        example 'redirect main page' do
          get new_user_path
          expect(response).to redirect_to('/tasks')
        end
      end

      context 'POST' do
        example 'redirect main page' do
          post users_path, params: { email: 'sample@rakuten.com', password: 'sample' }
          expect(response).to redirect_to('/tasks')
        end
      end
    end

    describe 'admin' do
      let!(:user) { create(:user, role_id: 'admin') }
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      context 'PATCH' do
        example 'users update' do
          patch user_path(user), params: { user: attributes_for(:user, email: 'sample') }
          expect(User.find(user.id).email).to eq('sample')
        end
      end

      context 'DESTROY' do
        example 'users delete' do
          member_user = create(:user, role_id: 'member')
          expect(User.count).to eq(2)
          expect do
            delete user_path(member_user), params: { id: member_user.id }
          end.to change { User.count }.by(-1)
        end
      end
    end
  end
end
