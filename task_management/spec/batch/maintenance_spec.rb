# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maintenance', type: :system do
  describe 'maintenance' do
    context 'メンテナンスモードを有効にした場合' do
      example 'メンテナンスモードを開始し、タスク管理システムにアクセス不可となる' do
        system('bundle exec rails runner lib/script/maintenance.rb 1')
        get login_path
        expect(response).to have_http_status 503
        visit login_path
        expect(page).to have_content '現在メンテナンス中です。'
      end
    end
    context 'メンテナンスモードを無効にした場合' do
      example 'メンテナンスモードを終了する、タスク管理システムにアクセス可能となる' do
        system('bundle exec rails runner lib/script/maintenance.rb 0')
        get login_path
        expect(response).to have_http_status 200
        visit login_path
        expect(page).to have_content 'ログイン'
        expect(page).not_to have_content '現在メンテナンス中です。'
      end
    end
  end
end
