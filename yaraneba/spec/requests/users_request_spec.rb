require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#users not logged in' do
    context 'GET' do
      example 'request OK' do
        get users_path
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
    let!(:user) { create(:user) }
    before do
      post login_path, params: { email: 'yu.oikawa@rakuten.com', password: '12345' }
    end

    context 'GET' do
      example 'redirect main page' do
        get users_path
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
end
