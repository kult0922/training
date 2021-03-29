require 'rails_helper'

RSpec.describe 'Logins', type: :request do
  let!(:user) { create(:user, role_id: 'member') }

  describe '#login new' do
    context 'GET' do
      example 'request OK' do
        get login_path
        expect(response).to have_http_status :ok
      end
    end
  end

  describe '#login create' do
    context 'POST' do
      example 'create session' do
        post login_path, params: { email: user.email, password: user.password }
        expect(response).to redirect_to('/tasks')
      end
    end
  end

  describe '#login destroy' do
    context 'DELETE' do
      example 'delete session' do
        post login_path, params: { email: user.email, password: user.password }
        delete login_path
        expect(response).to have_http_status :redirect
      end
    end
  end
end
