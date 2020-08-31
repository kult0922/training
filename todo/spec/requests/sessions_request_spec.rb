require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }

  describe 'GET /login' do
    it 'returns http success' do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    it 'returns http success' do
      post login_path params: { session: { account_name: user.id, password: user.password } }
      expect(response).to have_http_status(:success)
    end
  end

end
