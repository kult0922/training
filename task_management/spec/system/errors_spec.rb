# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Errors', type: :system do
  let!(:test_authority) do
    create(:authority,
           id: 1,
           role: 0,
           name: 'test')
  end
  let!(:test_index_user) do
    create(:user,
           id: 1,
           login_id: 'yokuno',
           authority_id: test_authority.id)
  end

  before do
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:session).and_return(user_id: test_index_user.id)
  end

  describe '404' do
    context '存在しないパスにアクセスした場合' do
      example '404ページを表示する' do
        visit task_path('test404')
        expect(current_path).to eq task_path('test404')
        expect(page).to have_content 'お探しのページは見つかりませんでした。'
      end
    end
  end

  describe '500' do
    context 'サーバエラーが発生した場合' do
      example '500ページを表示する' do
        allow_any_instance_of(TasksController)
          .to receive(:index).and_throw(Exception)
        visit tasks_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content '大変申し訳ありません。一時的なエラーが発生しました。'
      end
    end
  end
end
