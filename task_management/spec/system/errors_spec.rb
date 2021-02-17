# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Errors', type: :system do
  describe '404' do
    context '存在しないパスにアクセスした場合' do
      example '404ページが表示される' do
        not_found_path = "#{login_path}test404"
        visit not_found_path
        expect(current_path).to eq not_found_path
        expect(page).to have_content 'お探しのページは見つかりませんでした。'
      end
    end
  end

  describe '500' do
    context 'サーバエラーが発生した場合' do
      example '500ページが表示される' do
        allow_any_instance_of(SessionsController).to receive(:index)
          .and_throw(Exception)
        visit login_path
        expect(current_path).to eq login_path
        expect(page).to have_content '大変申し訳ありません。一時的なエラーが発生しました。'
      end
    end
  end
end
