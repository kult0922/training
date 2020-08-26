require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /login" do
    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ account_name: user.account_name, password_confirmation: user.password })
    end

    it "returns http success" do
      get "/projects"
      expect(response).to have_http_status(:success)
    end
  end

end
