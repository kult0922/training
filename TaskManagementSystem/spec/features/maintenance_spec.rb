require 'rails_helper'

RSpec.feature "Maintenances", type: :feature do
  # メンテナンス画面に切り替わる
  feature 'maintenance' do
    scenario 'change to maintenance screen' do
      # ログイン画面へ移動
      visit root_path
      # メンテナンス画面に切り替え
      Batches::MaintenanceBatch.start
      visit root_path
      expect(page).to have_content 'メンテナンス中です。。。'
    end

    scenario 'finish maintenance screen' do
      # ログイン画面へ移動
      visit root_path
      # メンテナンス画面の表示を終了
      Batches::MaintenanceBatch.end
      visit root_path
      expect(page).to have_content 'TMS'
    end
  end
end
