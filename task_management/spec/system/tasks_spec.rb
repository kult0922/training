# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  before do
    visit login_path
    fill_in 'login_id', with: user.login_id
    fill_in 'password', with: user.password
    click_button 'ログイン'
  end
  let(:authority) { create(:authority, role: 0, name: '管理者') }
  let(:user) { create(:user, login_id: 'yokuno', authority_id: authority.id) }
  let!(:added_user_task) { create(:task, creation_date: Time.current + 5.days, user_id: user.id) }

  describe '#index' do
    before { visit tasks_path }
    context 'トップページにアクセスした場合' do
      example 'タスク一覧が表示される' do
        expect(current_path).to eq tasks_path
        expect(page).to have_content added_user_task.name
      end
    end

    context '編集リンクを押下した場合' do
      example 'タスク編集画面に遷移する' do
        click_link "edit_link_#{added_user_task.id}"
        expect(page).to have_content 'タスク編集'
      end
    end

    context '削除ボタンを押下した場合' do
      let(:label_A) { create(:label, user_id: user.id, name: 'label_A') }
      let!(:rel_A) { create(:task_label_relation, task_id: added_user_task.id, label_id: label_A.id) }
      example '対象タスク、及び対応づくタスクテーブル-ラベルマスタ紐付テーブルが全て削除される' do
        page.accept_confirm do
          click_link "delete_link_#{added_user_task.id}"
        end
        expect(page).to have_content '削除しました。'
        expect(Task.where(id: added_user_task.id).count).to eq 0
        expect(TaskLabelRelation.where(task_id: added_user_task.id).count).to eq 0
      end
    end

    describe 'rooting' do
      before do
        page.accept_confirm { click_button 'ログアウト' }
      end
      context '一般権限のユーザでタスク管理画面にアクセスした場合' do
        before do
          fill_in 'login_id', with: general_user.login_id
          fill_in 'password', with: general_user.password
          click_button 'ログイン'
        end
        let(:general_authority) { create(:authority, role: 1, name: '一般') }
        let(:general_user) { create(:user, login_id: 'test_2', authority_id: general_authority.id) }
        let!(:general_task) { create(:task, name: '一般のタスク', user_id: general_user.id) }
        example 'タスク管理画面が表示される' do
          visit tasks_path
          expect(current_path).to eq tasks_path
          expect(page).to have_content general_task.name
        end
      end

      context 'ログインしていない状態でタスク管理画面にアクセスした場合' do
        example 'ログイン画面に遷移する' do
          visit tasks_path
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログイン'
        end
      end
    end

    describe 'search' do
      let!(:taskA) do
        create(:task, name: 'taskA',
                      creation_date: Time.current + 2.days,
                      user_id: user.id,
                      deadline: Time.current + 4.days,
                      status: 1)
      end
      let!(:taskB) do
        create(:task, name: 'taskB',
                      creation_date: Time.current + 2.days,
                      user_id: user.id,
                      deadline: Time.current + 4.days,
                      status: 2)
      end
      let!(:taskC) do
        create(:task, name: 'taskC',
                      creation_date: Time.current + 2.days,
                      user_id: user.id,
                      deadline: Time.current + 4.days,
                      status: 3)
      end

      context '検索キーワードを入力し、検索ボタンを押下した場合' do
        before do
          fill_in 'search_word', with: 'task'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content added_user_task.name
          expect(page).to have_content taskA.name
          expect(page).to have_content taskB.name
          expect(page).to have_content taskC.name
        end
      end

      context 'ステータス「全て」を選択し、検索ボタンを押下した場合' do
        before do
          choose 'all'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content added_user_task.name
          expect(page).to have_content taskA.name
          expect(page).to have_content taskB.name
          expect(page).to have_content taskC.name
        end
      end

      context 'ステータス｢未着手」を選択し、検索ボタンを押下した場合' do
        before do
          choose 'todo'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content taskA.name
        end
      end

      context 'ステータス「着手」を選択し、検索ボタンを押下した場合' do
        before do
          choose 'in_progress'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content taskB.name
        end
      end

      context 'ステータス「完了」を選択し、検索ボタンを押下した場合' do
        before do
          choose 'done'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content taskC.name
        end
      end

      context 'ステータス「着手」と検索キーワードを入力し、検索ボタンを押下した場合' do
        before do
          choose 'in_progress'
          fill_in 'search_word', with: 'task'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content taskB.name
        end
      end
    end

    describe 'label' do
      let(:user_task_labeled_A) { create(:task, name: 'task_labeled_A', user_id: user.id) }
      let(:user_task_labeled_B) { create(:task, name: 'task_labeled_B', user_id: user.id) }
      let!(:user_task_unlabeled) { create(:task, name: 'task_unlabeled', user_id: user.id) }
      let(:label_A) { create(:label, user_id: user.id, name: 'label_A') }
      let(:label_B) { create(:label, user_id: user.id, name: 'label_B') }
      let!(:rel_A) { create(:task_label_relation, task_id: user_task_labeled_A.id, label_id: label_A.id) }
      let!(:rel_B) { create(:task_label_relation, task_id: user_task_labeled_B.id, label_id: label_B.id) }
      before { visit tasks_path }
      context 'ラベルを全て選択して検索ボタンを押下した場合' do
        example 'ラベルありのタスクが表示される' do
          check 'all-select'
          click_button '検索'
          expect(page).to have_content user_task_labeled_A.name
          expect(page).to have_content user_task_labeled_B.name
          expect(page).not_to have_content user_task_unlabeled.name
        end
      end

      context 'ラベルを全て選択せずに検索ボタンを押下した場合' do
        example 'ラベルなしのタスクが表示される' do
          uncheck 'all-select'
          click_button '検索'
          expect(page).to have_content user_task_unlabeled.name
          expect(page).not_to have_content user_task_labeled_A.name
          expect(page).not_to have_content user_task_labeled_B.name
        end
      end

      context 'ラベルAを選択して検索ボタンを押下した場合' do
        example 'ラベルAのタスクのみが表示される' do
          check "label_ids_#{label_A.id}"
          click_button '検索'
          expect(page).to have_content user_task_labeled_A.name
          expect(page).not_to have_content user_task_labeled_B.name
          expect(page).not_to have_content user_task_unlabeled.name
        end
      end
    end

    describe 'sorting' do
      let!(:taskA) do
        create(:task, name: 'taskA',
                      creation_date: Time.zone.now + 2.days,
                      user_id: user.id,
                      deadline: Time.zone.now + 4.days)
      end
      let!(:taskB) do
        create(:task, name: 'taskB',
                      creation_date: Time.zone.now + 3.days,
                      user_id: user.id,
                      deadline: Time.zone.now + 1.day)
      end
      before { visit root_path }
      context 'トップページにアクセスした場合（サーバ側で「作成日時」を降順ソート）' do
        example '「作成日時」で降順ソートされた状態で表示される' do
          expect(page.body.index(taskA.name)).to be > page.body.index(taskB.name)
        end
      end

      context '「終了期限」の降順ソートリンクを押下した場合' do
        example '「終了期限」で降順ソートされた状態で表示される' do
          click_link 'deadline_desc'
          until page.has_link?('deadline_asc'); end
          expect(page.body.index(taskB.name)).to be > page.body.index(taskA.name)
        end
      end

      context '「終了期限」の昇順ソートリンクを押下した場合' do
        example '「終了期限」で昇順ソートされた状態で表示される' do
          click_link 'deadline_desc'
          click_link 'deadline_asc'
          until page.has_link?('deadline_desc'); end
          expect(page.body.index(taskA.name)).to be > page.body.index(taskB.name)
        end
      end
    end

    describe 'paging' do
      let!(:tasks) { create_list(:task, 25, creation_date: Time.zone.now + 30.days, user_id: user.id) }
      before { visit root_path }
      context 'ページングの「最初」リンクを押下した場合' do
        example '最初のページにタスクが25件表示される' do
          click_link '最後'
          click_link '最初'
          tasks.each do |task|
            expect(page).to have_content task.name
          end
        end
      end

      context 'ページングの「最後」リンクを押下した場合' do
        example '最後のページにタスクが1件表示される' do
          click_link '最後'
          expect(page).to have_content added_user_task.name
        end
      end

      context 'ページングの「前」リンクを押下した場合' do
        example '最初のページにタスクが25件表示される' do
          click_link '次'
          click_link '前'
          tasks.each do |task|
            expect(page).to have_content task.name
          end
        end
      end

      context 'ページングの「次」リンクを押下した場合' do
        example '最後のページにタスクが1件表示される' do
          click_link '次'
          expect(page).to have_content added_user_task.name
        end
      end

      context 'ページングの「1」リンクを押下した場合' do
        example '最初のページにタスクが25件表示される' do
          click_link '2'
          click_link '1'
          tasks.each do |task|
            expect(page).to have_content task.name
          end
        end
      end

      context 'ページングの「2」リンクを押下した場合' do
        example '最後のページにタスクが1件表示される' do
          click_link '2'
          expect(page).to have_content added_user_task.name
        end
      end
    end
  end

  describe '#show(task_id)' do
    context 'タスク詳細画面にアクセスした場合' do
      example 'タスク詳細画面が表示される' do
        visit task_path(added_user_task)
        expect(current_path).to eq task_path(added_user_task)
      end
    end

    context 'ログインユーザに対応付かないタスクIDを用いてタスク詳細画面にアクセスした場合' do
      let(:other_user) { create(:user, login_id: 'test_user_2', authority_id: authority.id) }
      let!(:added_other_user_task) { create(:task, creation_date: Time.current + 1.day, user_id: other_user.id) }
      example '404ページに遷移する' do
        visit task_path(added_other_user_task)
        expect(current_path).to eq task_path(added_other_user_task)
        expect(page).to have_content 'お探しのページは見つかりませんでした。'
      end
    end
  end

  describe '#new' do
    before { visit new_task_path }
    let(:name) { 'test_task_new' }
    let(:details) { 'test_description_new' }
    let(:deadline) { Time.zone.now + 3.days }
    context 'タスク登録画面にアクセスした場合' do
      example 'タスク登録画面が表示される' do
        expect(current_path).to eq new_task_path
      end
    end

    context '全項目を入力して登録ボタンを押下した場合' do
      before do
        fill_in 'name', with: name
        fill_in 'details', with: details
        fill_in 'deadline', with: deadline
        select '中', from: 'task[priority]'
        select '着手', from: 'task[status]'
      end
      example 'タスクを登録できる' do
        click_button '登録'
        expect(page).to have_content '登録が完了しました。'
      end
    end

    context '必須項目を入力せず、登録ボタンを押下した場合' do
      before do
        fill_in 'name', with: ''
        fill_in 'details', with: details
        fill_in 'deadline', with: deadline
        select '中', from: 'task[priority]'
        select '着手', from: 'task[status]'
      end
      example 'タスクが登録できない' do
        click_button '登録'
        expect(page).to have_content 'タスク名を入力してください'
      end
    end

    context 'ラベル登録のテスト' do
      let!(:label_A) { create(:label, user_id: user.id, name: 'label_A') }
      before { visit new_task_path }
      context '必須項目を入力し、ラベルAを選択して登録した場合' do
        before do
          fill_in 'name', with: name
          fill_in 'details', with: details
          fill_in 'deadline', with: deadline
          select '高', from: 'task[priority]'
          select '完了', from: 'task[status]'
          check "task_label_ids_#{label_A.id}"
        end
        example 'タスクを登録できる' do
          click_button '登録'
          expect(page).to have_content '登録が完了しました。タスク名：' + name
        end
      end

      context '必須項目を入力せず、ラベルAを選択して登録した場合' do
        before do
          fill_in 'name', with: ''
          fill_in 'details', with: details
          fill_in 'deadline', with: deadline
          select '中', from: 'task[priority]'
          select '着手', from: 'task[status]'
          check "task_label_ids_#{label_A.id}"
        end
        example 'タスクが登録できない' do
          click_button '登録'
          expect(page).to have_content 'タスク名を入力してください'
        end
      end
    end
  end

  describe '#edit' do
    before { visit edit_task_path(added_user_task) }
    let(:name) { 'test_task_edit' }
    let(:details) { 'test_description_edit' }
    let(:deadline) { Time.zone.now + 5.days }
    context 'タスク編集画面にアクセスした場合' do
      example 'タスク編集画面が表示される' do
        visit edit_task_path(added_user_task)
        expect(current_path).to eq edit_task_path(added_user_task)
      end
    end

    context 'ログインユーザに対応付かないタスクIDを用いてタスク編集画面にアクセスした場合' do
      let(:other_user) { create(:user, login_id: 'test_user_2', authority_id: authority.id) }
      let!(:added_other_user_task) { create(:task, creation_date: Time.current + 1.day, user_id: other_user.id) }
      example '404ページに遷移する' do
        visit edit_task_path(added_other_user_task)
        expect(current_path).to eq edit_task_path(added_other_user_task)
        expect(page).to have_content 'お探しのページは見つかりませんでした。'
      end
    end

    context '全項目を入力し、更新ボタンを押下した場合' do
      before do
        fill_in 'name', with: name
      end
      example 'タスクを更新できる' do
        click_button '更新'
        expect(page).to have_content '更新が完了しました。'
      end
    end

    context '必須項目を入力せず、更新ボタンを押下した場合' do
      before do
        fill_in 'name', with: ''
      end
      example 'タスクが更新できない' do
        click_button '更新'
        expect(page).to have_content 'タスク名を入力してください'
      end
    end

    context 'ラベル更新のテスト' do
      let(:user_task_labeled_A) { create(:task, name: 'task_labeled_A', user_id: user.id) }
      let(:label_A) { create(:label, user_id: user.id, name: 'label_A') }
      let!(:label_B) { create(:label, user_id: user.id, name: 'label_B') }
      let!(:rel_A) { create(:task_label_relation, task_id: user_task_labeled_A.id, label_id: label_A.id) }
      before { visit edit_task_path(user_task_labeled_A) }
      context '必須項目を入力し、ラベルBを選択して更新した場合' do
        before do
          fill_in 'name', with: ''
          fill_in 'name', with: name
          fill_in 'details', with: details
          fill_in 'deadline', with: deadline
          select '高', from: 'task[priority]'
          select '完了', from: 'task[status]'
          check "task_label_ids_#{label_B.id}"
        end
        example 'タスクを更新できる' do
          click_button '更新'
          expect(page).to have_content '更新が完了しました。タスク名：' + name
        end
      end

      context '必須項目を入力し、ラベルAの選択を外して更新した場合' do
        before do
          fill_in 'name', with: ''
          fill_in 'name', with: name
          fill_in 'details', with: details
          fill_in 'deadline', with: deadline
          select '高', from: 'task[priority]'
          select '完了', from: 'task[status]'
          check "task_label_ids_#{label_A.id}"
        end
        example 'タスクを更新できる' do
          click_button '更新'
          expect(page).to have_content '更新が完了しました。タスク名：' + name
        end
      end
    end
  end

  describe '#update' do
    context 'ログインユーザに対応付かないタスクIDを用いてタスク更新をした場合' do
      let(:other_user) { create(:user, login_id: 'test_user_2', authority_id: authority.id) }
      let!(:added_other_user_task) { create(:task, creation_date: Time.current + 1.day, user_id: other_user.id) }
      example 'タスクが更新できない' do
        patch task_path(added_user_task), params: { id: added_other_user_task.id,
                                                    name: added_other_user_task.name }
        expect(added_user_task.reload.name).not_to eq added_other_user_task.name
        expect(added_user_task.reload.name).to eq added_user_task.name
      end
    end
  end

  describe '#destroy' do
    context 'ログインユーザに対応付かないタスクIDを用いてタスク削除をした場合' do
      let(:other_user) { create(:user, login_id: 'test_user_2', authority_id: authority.id) }
      let!(:added_other_user_task) { create(:task, creation_date: Time.current + 1.day, user_id: other_user.id) }
      example 'タスクが削除できない' do
        delete task_path(added_user_task), params: { id: added_other_user_task.id }
        expect(added_user_task.reload.name).not_to eq added_other_user_task.name
        expect(added_user_task.reload.name).to eq added_user_task.name
      end
    end
  end

  describe 'logout' do
    context 'ログアウトボタンを押下した場合' do
      example 'ログアウトし、ログイン画面に遷移する' do
        page.accept_confirm { click_button 'ログアウト' }
        expect(page).to have_content 'ログアウトしました。'
        expect(page).to have_current_path login_path
      end
    end
  end
end
