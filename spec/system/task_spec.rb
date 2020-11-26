require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before(:each) do
    @task = create(:task)
  end

  context '画面表示が正常' do
    it 'タスク一覧画面が表示されること' do
      visit '/'
      expect(page).to have_content 'タスク一覧画面'
    end

    it 'タスク登録画面が表示されること' do
      visit 'tasks/newtask'
      expect(page).to have_content 'タスク登録画面'
    end

    it 'タスク詳細画面が表示されること' do
      visit "tasks/taskdetail/#{@task.id}"
      expect(page).to have_content 'タスク詳細画面'
    end

    it 'タスク更新画面が表示されること' do
      visit "tasks/taskupdate/#{@task.id}"
      expect(page).to have_content 'タスク更新画面'
    end
  end

  context 'フォームの入力値が正常' do
    it 'タスク登録処理' do
      # 登録画面へ遷移
      visit tasks_newtask_path

      # ステータスで着手を選択
      select '着手', from: 'task[status]'

      # タイトルに「テストタイトル登録 from rspec」と入力
      fill_in 'タイトル', with: 'テストタイトル登録 from rspec'

      # 内容に「テスト内容登録 from rspec」と入力
      fill_in '内容', with: 'テスト内容登録 from rspec'

      # 送信ボタンをクリック
      click_button '送信'

      # タスク一覧画面へ遷移することを期待する
      expect(current_path).to eq root_path

      # タスク一覧画面で登録成功のFlashメッセージが表示されることを確認する
      expect(page).to have_content '登録に成功しました！'
    end

    it 'タスク更新処理' do
      # 更新画面へ遷移
      visit "tasks/taskupdate/#{@task.id}"

      # タイトルに「テストタイトル更新 from rspec」と入力
      fill_in 'タイトル', with: 'テストタイトル更新 from rspec'

      # 内容に「テスト詳細更新 from rspec」と入力
      fill_in '詳細', with: 'テスト詳細更新 from rspec'

      # 更新ボタンをクリック
      click_button '更新'

      # タスク一覧画面へ遷移することを期待する
      expect(current_path).to eq root_path

      # タスク一覧画面で更新成功のFlashメッセージが表示されることを確認する
      expect(page).to have_content '更新に成功しました！'
    end

    it 'タスク削除処理' do
      # 詳細画面へ遷移
      visit "tasks/taskdetail/#{@task.id}"

      # 削除ボタンをクリック
      click_link '削除'

      # タスク一覧画面へ遷移することを期待する
      expect(current_path).to eq root_path

      # タスク一覧画面で削除成功のFlashメッセージが表示されることを確認する
      expect(page).to have_content '削除に成功しました！'
    end
  end
end
