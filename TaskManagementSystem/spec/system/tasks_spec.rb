require 'rails_helper'

RSpec.describe 'Tasks', type: :system do

  # タスク一覧画面内のテスト
  describe 'TaskIndex' do
    before do
      @task = create(:valid_sample_task)
    end

    it 'shows all tasks' do
      # タスク一覧画面を開く
      visit root_path

      # テーブルのタイトルが表示されている
      expect(page).to have_content('優先度')
      expect(page).to have_content('タスク名')
      expect(page).to have_content('ラベル')
      expect(page).to have_content('終了期限')
      expect(page).to have_content('ステータス')
      expect(page).to have_content('詳細')
      expect(page).to have_content('編集')
      expect(page).to have_content('削除')
      
      # テーブルにタスクが出力されている
      expect(page).to have_content(@task.priority)
      expect(page).to have_content(@task.title)
      expect(page).to have_content('ラベル')
      expect(page).to have_content(@task.deadline.strftime('%Y/%m/%d'))
      expect(page).to have_content(@task.status_i18n)

      # リンクの存在確認
      click_link ('詳細')
      click_link ('タスク一覧')
      click_link ('編集')
      click_link ('タスク一覧')
      click_link ('ラベル作成')
      click_link ('検索')

      # 削除できているか確認
      click_link ('削除')
      expect(Task.all.count).to eq (0)
    end  
  end

  # タスク詳細画面内のテスト
  describe 'TaskShow' do
    before do
      @task = create(:valid_sample_task)
    end

    it 'show Task detail data' do
      # タスク詳細画面を開く
      visit task_path(@task)

      # ページタイトルとテーブルのタイトルが表示されている
      expect(page).to have_content("#{@task.title}の詳細")
      expect(page).to have_content('優先度')
      expect(page).to have_content('終了期限')
      expect(page).to have_content('ステータス')
      expect(page).to have_content('ラベル')
      expect(page).to have_content('説明')
      expect(page).to have_content('編集')
      expect(page).to have_content('削除')      
      
      # リンクの存在確認
      click_link ('編集')
      click_link ('タスク一覧')
      click_link ('詳細')

      # 削除できているか確認(一覧画面から１減っている)
      click_link ('削除')
      expect(Task.all.count).to eq (0)      
    end
  end

  # タスク登録画面のテスト
  describe 'TaskNew' do
    it 'can create new task' do
      # タスク登録画面を開く
      visit new_task_path

      # title要素の文言確認
      expect(page).to have_title('タスク登録')
      
      # リンクの存在確認
      click_link('タスク一覧')
      visit new_task_path
      click_link('ユーザー管理')
      visit tasks_path
      visit new_task_path

      # ラベル名が正しく表示されている
      expect(page).to have_content('タスク名')
      expect(page).to have_content('優先度')
      expect(page).to have_content('終了期限')
      expect(page).to have_content('説明')

      # セレクトボックス・テキストフィールドへの入力
      fill_in('タスク名', with: 'テストタスク')
      fill_in('優先度', with: 1)
      select('2025', from: 'task[deadline(1i)]')
      select('1月', from: 'task[deadline(2i)]')
      select('23', from: 'task[deadline(3i)]')
      select('09', from: 'task[deadline(4i)]')
      select('26', from: 'task[deadline(5i)]')
      fill_in('説明', with: 'テストタスクの説明')

      # 新規登録ボタンのクリック
      click_button 'commit'
    end
  end

  # タスク編集画面のテスト
  describe 'TaskEdit' do
      before do
        @task = create(:valid_sample_task)
      end

    it 'can edit task' do
      # タスク登録画面を開く
      visit edit_task_path(@task)

      # title要素の文言確認
      expect(page).to have_title('タスク編集')

      # リンクの存在確認
      click_link('タスク一覧')
      visit edit_task_path(@task)
      click_link('ユーザー管理')
      visit tasks_path
      visit edit_task_path(@task)
      
      # ラベル名が正しく表示されている
      expect(page).to have_content('タスク名')
      expect(page).to have_content('ステータス')
      expect(page).to have_content('優先度')
      expect(page).to have_content('終了期限')
      expect(page).to have_content('説明')

      # 保存済タスクのデータが初期値として入力されている
      expect(page).to have_field('タスク名', with: @task.title)
      expect(page).to have_field('ステータス', with: @task.status)
      expect(page).to have_field('優先度', with: @task.priority)
      expect(page).to have_content(@task.deadline.year)
      expect(page).to have_content(@task.deadline.month)
      expect(page).to have_content(@task.deadline.day)
      expect(page).to have_content(@task.deadline.hour)
      expect(page).to have_content(@task.deadline.min)
      expect(page).to have_content(@task.deadline.sec)
      expect(page).to have_field('説明', with: @task.description)

      # セレクトボックス・テキストフィールドの編集ができる
      fill_in 'タスク名', with: 'テストタスク'
      fill_in '優先度', with: 1
      select '2025', from: 'task[deadline(1i)]'
      select '1月', from: 'task[deadline(2i)]'
      select '23', from: 'task[deadline(3i)]'
      select '09', from: 'task[deadline(4i)]'
      select '26', from: 'task[deadline(5i)]'
      fill_in '説明', with: 'テストタスクの説明'

      # 編集ボタンのクリック
      click_button 'commit'
    end
  end
end
