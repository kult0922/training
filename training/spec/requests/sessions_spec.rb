require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'not login' do
    it 'can not access to tasks page' do
      get tasks_path
      expect(response).to redirect_to(new_sessions_path)
    end
  end

  describe 'sessions#new' do
    it 'access ok' do
      get new_sessions_path
      expect(response).to be_successful
    end
  end

  describe 'sessions#create' do
    context 'login success' do
      before do
        post sessions_path, params: { email: user.email, password: user.password }
      end

      it 'redirect to root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'access tasks page' do
        get tasks_path
        expect(response).to be_successful
      end
    end

    context 'login fail' do
      context 'wrong email' do
        before do
          post sessions_path, params: { email: 'wrong_password@test.com', password: user.password }
        end

        it 'redirect to new_session_path' do
          expect(response).to redirect_to(new_sessions_path)
        end

        it 'can not access to tasks page' do
          get tasks_path
          expect(response).to redirect_to(new_sessions_path)
        end
      end

      context 'wrong password' do
        before do
          post sessions_path, params: { email: user.email, password: 'wrong_password' }
        end

        it 'redirect to new_session_path' do
          expect(response).to redirect_to(new_sessions_path)
        end

        it 'can not access to tasks page' do
          get tasks_path
          expect(response).to redirect_to(new_sessions_path)
        end
      end
    end

    describe 'sessions#destroy' do
      before do
        post sessions_path, params: { email: user.email, password: user.password }
        delete sessions_path
      end

      it 'logout success' do
        expect(response).to redirect_to(new_sessions_path)
      end

      it 'can not access to tasks page' do
        get tasks_path
        expect(response).to redirect_to(new_sessions_path)
      end
    end
  end
end
