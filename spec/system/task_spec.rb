require 'rails_helper'

RSpec.describe "Tasks", type: :system do
    it 'タスク一覧画面が表示されること' do
        visit '/'
    end

    context 'フォームの入力値が正常' do
        it 'タスク登録処理' do
            # 登録画面へ遷移
            visit tasks_newtask_path

            # ステータスで着手を選択
            select '着手', from: 'task[status]'

            # タイトルに「テストタイトル from rspec」と入力
            fill_in 'タイトル', with: 'テストタイトル from rspec'

            # 内容に「テスト内容 from rspec」と入力
            fill_in '内容', with: 'テスト内容 from rspec'

            # 送信ボタンをクリック
            click_button '送信'

            # タスク一覧画面へ遷移することを期待する
            expect(current_path).to eq root_path

            # タスク一覧画面で登録成功のFlashメッセージが表示されることを確認する
            expect(page).to have_content '登録に成功しました！'
        end
    end

end
