# frozen_string_literal: true

require 'rails_helper'
require 'pp'

RSpec.describe 'Maintenance', type: :system do
  subject { page }

  describe 'メンテナンス開始' do
    it do
      system('bundle exec rails runner Batch::Maintenance.start')
      get login_path
      expect(response).to have_http_status 503
      visit root_path
      is_expected.to have_content 'メンテナンス中'
    end
  end

  describe 'メンテナンス終了' do
    it do
      system('bundle exec rails runner Batch::Maintenance.end')
      get login_path
      expect(response).to have_http_status 200
      visit root_path
      is_expected.not_to have_content 'メンテナンス中'
    end
  end
end
