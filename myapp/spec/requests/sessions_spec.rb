# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    subject(:action) do
      login_request_as(user)
      response
    end

    let(:user) { create(:user) }

    it 'log in as an existing user' do
      action
      expect(response).to have_http_status(:found)
    end

    context 'when access tasks without logging in' do
      it 'redirect_to login_path' do
        # dont call action
        get tasks_path
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'DELETE /logout' do
    subject(:action) do
      login_request_as(user)
      delete logout_path
      response
    end

    let(:user) { create(:user) }

    it 'redirect_to login_path' do
      action
      expect(response).to redirect_to login_path
    end
  end
end
