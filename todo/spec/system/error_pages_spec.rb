# frozen_string_literal: true

require 'rails_helper'

describe '#Exception', type: :system do
  context 'move to project/test page expect 404 error' do
    it 'render 404 error' do
      visit '/test'
      expect(page).to have_content '探しているページが存在しません。'
    end
  end

  context 'when exception reised' do
    it 'render 500 error' do
      allow(Project).to receive(:all).and_raise(RuntimeError)
      visit projects_path
      expect(page).to have_content 'サーバに問題が発生しました。'
  end
end
