require 'rails_helper'

RSpec.describe "Admin::Sessions", type: :request do
  let(:admin) { FactoryBot.create(:user) }
  let(:not_admin) { FactoryBot.create(:user, is_admin: false) }

  context 'not logged in' do
    it 'can not access to tasks page' do
      get admin_users_path
      expect(response).to redirect_to(new_admin_sessions_path)
    end
  end

  context 'login as admin' do
    describe 'new' do
      it 'access ok' do
        get new_admin_sessions_path
        expect(response).to be_successful
      end

      it 'login and redirect to root path' do
        post admin_sessions_path, params: { email: admin.email, password: admin.password }
        get new_admin_sessions_path
        expect(response).to redirect_to(admin_users_path)
      end
    end

    describe 'create' do
      context 'login success' do
        before do
          post admin_sessions_path, params: { email: admin.email, password: admin.password }
        end

        it 'redirect to root path' do
          expect(response).to redirect_to(admin_users_path)
        end

        it 'access tasks page' do
          get admin_root_path
          expect(response).to be_successful
        end
      end

      context 'login fail' do
        context 'wrong email' do
          before do
            post admin_sessions_path, params: { email: 'wrong_email@test.com', password: admin.password }
          end

          it 'redirect to new_session_path' do
            expect(response).to redirect_to(new_admin_sessions_path)
          end

          it 'can not access to tasks page' do
            get admin_users_path
            expect(response).to redirect_to(new_admin_sessions_path)
          end
        end

        context 'wrong password' do
          before do
            post admin_sessions_path, params: { email: admin.email, password: 'wrong_password' }
          end

          it 'redirect to new_session_path' do
            expect(response).to redirect_to(new_admin_sessions_path)
          end

          it 'can not access to tasks page' do
            get admin_users_path
            expect(response).to redirect_to(new_admin_sessions_path)
          end
        end
      end
    end

    describe 'destroy' do
      before do
        post admin_sessions_path, params: { email: admin.email, password: admin.password }
        delete admin_sessions_path
      end

      it 'logout success' do
        expect(response).to redirect_to(new_admin_sessions_path)
      end

      it 'can not access to tasks page' do
        get admin_users_path
        expect(response).to redirect_to(new_admin_sessions_path)
      end
    end
  end

  context 'not admin' do
    describe 'create' do
      it 'can not login' do
        post admin_sessions_path, params: { email: not_admin.email, password: not_admin.password }
        expect(response).to redirect_to(new_admin_sessions_path)
      end
    end
  end
end
