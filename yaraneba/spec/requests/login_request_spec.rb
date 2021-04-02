require 'rails_helper'

RSpec.describe 'Logins', type: :request do
  let!(:user) { create(:user, role_id: 'member') }

  describe 'new' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'reidrect task page' do
        get login_path
        expect(response).to redirect_to('/tasks')
      end
    end

    context 'not logged in' do
      example 'response OK' do
        get login_path
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'create' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'create session successfully' do
        post login_path, params: { email: user.email, password: user.password }
        expect(session[:id].present?).to eq true
      end
    end

    context 'not logged in' do
      example 'redirect task page' do
        post login_path, params: { email: user.email, password: user.password }
        expect(response).to redirect_to('/tasks')
      end
    end
  end

  describe 'destroy' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'delete session' do
        delete login_path
        expect(session[:id].blank?).to eq true
      end
    end

    context 'not logged in' do
      example 'destroy session successfully' do
        delete login_path
        expect(response).to redirect_to('/')
      end
    end
  end
end
