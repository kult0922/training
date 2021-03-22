require 'rails_helper'

RSpec.describe 'Logins', type: :request do
  let!(:user) { create(:user) }

  describe '#login new' do
    context 'GET' do
      example 'request OK' do
        get login_path
        expect(response.status).to eq(200)
      end
    end
  end

  describe '#login create' do
    context 'POST' do
      example 'create session' do
        post login_path, params: { email: 'yu.oikawa@rakuten.com', password: '12345' }
        expect(response).to redirect_to('/tasks')
      end
    end
  end

  describe '#login destroy' do
    context 'DELETE' do
      example 'delete session' do
        post login_path, params: { email: 'yu.oikawa@rakuten.com', password: '12345' }
        delete login_path
        expect(response.status).to eq(302)
      end
    end
  end
end
