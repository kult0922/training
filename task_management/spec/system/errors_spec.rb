# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Errors', type: :system do
  describe '404' do
    context '存在しないパスにアクセスした場合' do
      example '404ページが表示される' do
        visit task_path('test404')
        expect(current_path).to eq task_path('test404')
        expect(page).to have_content 'お探しのページは見つかりませんでした。'
      end
    end
  end

  describe '500' do
    context 'サーバエラーが発生した場合' do
      example '500ページが表示される' do
        allow_any_instance_of(TasksController).to receive(:index)
          .and_throw(Exception)
        visit tasks_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content '大変申し訳ありません。一時的なエラーが発生しました。'
      end
    end
  end
end
