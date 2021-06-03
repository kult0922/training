# frozen_string_literal: true

require 'rails_helper'

Rails.application.load_tasks

describe 'Maintenance' do
  context 'メンテナンスIN' do
    it 'メンテナンスファイルが作成される' do
      Rake::Task['maintenance:on'].invoke
      expect(File.exist?(Rails.root.join(MAINTENANCE_FILE_NAME))).to eq(true)
    end
  end

  context 'メンテナンスOUT' do
    it 'メンテナンスファイルが削除される' do
      Rake::Task['maintenance:off'].invoke
      expect(File.exist?(Rails.root.join(MAINTENANCE_FILE_NAME))).to eq(false)
    end
  end
end
