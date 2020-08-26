require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }

  describe 'GET /login' do
    # before do
    #   allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ account_id: user.id, password_digest: user.password_digest })
    # end
    it 'returns http success' do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    it 'returns http success' do
      post login_path params: { session_form: { account_name: user.id, password: user.password } }
    end
  end

end
