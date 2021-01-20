# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:test_name) { 'test_task2' }
  let(:test_details) { 'test2_description' }
  let(:test_deadline) { Time.zone.now + 3.days }
  let(:test_priority) { Task.priorities.key(1) }
  let(:test_status) { Task.statuses.key(2) }
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
  let!(:test_label_A) do
    create(:label,
           id: 1,
           user_id: test_index_user.id,
           name: 'test_label_A')
  end
  let!(:test_label_B) do
    create(:label,
           id: 2,
           user_id: test_index_user.id,
           name: 'test_label_B')
  end
  let!(:test_label_C) do
    create(:label,
           id: 3,
           user_id: test_index_user.id,
           name: 'test_label_C')
  end
  let!(:test_rel_A) do
    create(:task_label_relation,
           task_id: added_index_task.id,
           label_id: test_label_A.id)
  end
  let!(:test_rel_B) do
    create(:task_label_relation,
           task_id: added_index_task.id,
           label_id: test_label_B.id)
  end
  let!(:test_rel_C) do
    create(:task_label_relation,
           task_id: added_index_task.id,
           label_id: test_label_C.id)
  end
  let!(:added_index_task) do
    create(:task,
           id: 2,
           creation_date: Time.current + 5.days,
           user_id: test_index_user.id)
  end
  let!(:added_index_task_unlabeled) do
    create(:task,
           id: 10,
           name: 'test_task_unlabeled',
           creation_date: Time.current + 6.days,
           user_id: test_index_user.id)
  end

  let!(:test_user) do
    create(:user,
           id: 2,
           login_id: 'test_user_2',
           authority_id: test_authority.id)
  end
  let!(:added_task) do
    create(:task,
           name: 'test_task',
           creation_date: Time.current + 1.day,
           user_id: test_user.id)
  end

  before do
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:session).and_return(user_id: test_index_user.id)
  end

  describe '#index' do
    before { visit root_path }
    context 'トップページにアクセスした場合' do
      example 'タスク一覧が表示される' do
        expect(page).to have_content added_task.name
      end
    end

    context '編集リンクを押下した場合' do
      example 'タスク編集画面に遷移する' do
        click_link 'edit_link_1'
        expect(page).to have_content 'タスク編集'
      end
    end

    context '削除ボタンを押下した場合' do
      example 'タスクを削除できる' do
        page.accept_confirm do
          click_link 'delete_link_1'
        end
        expect(page).to have_content '削除しました。タスク名：' + added_task.name
      end
    end

    describe 'search' do
      let!(:taskC) do
        create(:task,
               name: 'taskC',
               creation_date: Time.current + 2.days,
               user_id: test_index_user.id,
               deadline: Time.current + 4.days,
               status: 1)
      end
      let!(:taskD) do
        create(:task,
               name: 'taskD',
               creation_date: Time.current + 2.days,
               user_id: test_index_user.id,
               deadline: Time.current + 4.days,
               status: 2)
      end
      let!(:taskE) do
        create(:task,
               name: 'taskE',
               creation_date: Time.current + 2.days,
               user_id: test_index_user.id,
               deadline: Time.current + 4.days,
               status: 3)
      end
      let!(:test_rel_D) do
        create(:task_label_relation,
               task_id: taskC.id,
               label_id: test_label_A.id)
      end
      let!(:test_rel_E) do
        create(:task_label_relation,
               task_id: taskD.id,
               label_id: test_label_B.id)
      end
      let!(:test_rel_F) do
        create(:task_label_relation,
               task_id: taskE.id,
               label_id: 3)
      end

      context 'キーワード検索のテスト' do
        context '検索キーワードを入力し、検索ボタンを押下した場合' do
          before do
            fill_in 'search_word', with: 'task'
          end
          example 'タスクを検索できる' do
            click_button '検索'
            expect(page).to have_content added_task.name
            expect(page).to have_content 'taskC'
            expect(page).to have_content 'taskD'
            expect(page).to have_content 'taskE'
          end
        end
      end

      context 'ステータス検索のテスト' do
        context 'ステータス「全て」を選択し、検索ボタンを押下した場合' do
          before do
            choose 'all'
          end
          example 'タスクを検索できる' do
            click_button '検索'
            expect(page).to have_content added_task.name
            expect(page).to have_content 'taskC'
            expect(page).to have_content 'taskD'
            expect(page).to have_content 'taskE'
          end
        end

        context 'ステータス｢未着手」を選択し、検索ボタンを押下した場合' do
          before do
            choose 'todo'
          end
          example 'タスクを検索できる' do
            click_button '検索'
            expect(page).to have_content 'taskC'
          end
        end

        context 'ステータス「着手」を選択し、検索ボタンを押下した場合' do
          before do
            choose 'in_progress'
          end
          example 'タスクを検索できる' do
            click_button '検索'
            expect(page).to have_content 'taskD'
          end
        end

        context 'ステータス「完了」を選択し、検索ボタンを押下した場合' do
          before do
            choose 'done'
          end
          example 'タスクを検索できる' do
            click_button '検索'
            expect(page).to have_content 'taskE'
          end
        end

        context 'ステータス「着手」と検索キーワードを入力し、検索ボタンを押下した場合' do
          before do
            choose 'in_progress'
            fill_in 'search_word', with: 'task'
          end
          example 'タスクを検索できる' do
            click_button '検索'
            expect(page).to have_content 'taskD'
          end
        end
      end

      context 'ラベル検索のテスト' do
        context 'ラベルを全て選択して検索ボタンを押下した場合' do
          example 'ラベルありのタスクが表示される' do
            click_button '検索'
            expect(page).to have_content added_task.name
            expect(page).to have_content 'taskC'
            expect(page).to have_content 'taskD'
            expect(page).to have_content 'taskE'
          end
        end

        context 'ラベルを全て選択せずに検索ボタンを押下した場合' do
          before do
            uncheck 'all-select'
          end
          example 'ラベルなしのタスクが表示される' do
            click_button '検索'
            expect(page).to have_content added_index_task_unlabeled.name
            expect(page).not_to have_content 'taskC'
            expect(page).not_to have_content 'taskD'
            expect(page).not_to have_content 'taskE'
          end
        end

        context 'ラベルAを選択して検索ボタンを押下した場合' do
          before do
            uncheck 'label_ids_2'
            uncheck 'label_ids_3'
          end
          example 'ラベルAのタスクのみが表示される' do
            click_button '検索'
            expect(page).to have_content 'taskC'
            expect(page).not_to have_content added_index_task_unlabeled.name
            expect(page).not_to have_content 'taskD'
            expect(page).not_to have_content 'taskE'
          end
        end
      end
    end

    describe 'sorting' do
      let!(:taskA) do
        create(:task,
               name: 'taskA',
               creation_date: Time.current + 2.days,
               user_id: test_index_user.id,
               deadline: Time.current + 4.days)
      end
      let!(:taskB) do
        create(:task,
               name: 'taskB',
               creation_date: Time.current + 3.days,
               user_id: test_index_user.id,
               deadline: Time.current + 1.day)
      end
      before do
        visit root_path
      end
      context 'トップページにアクセスした場合（サーバ側で「作成日時」を降順ソート）' do
        example '「作成日時」で降順ソートされた状態で表示される' do
          expect(page.body.index(taskA.name))
            .to be > page.body.index(taskB.name)
        end
      end

      context '「終了期限」のソートリンクを押下した場合' do
        example '「終了期限」で降順ソートされた状態で表示される' do
          click_link 'deadline_desc'
          sleep 1
          expect(page.body.index(taskB.name))
            .to be > page.body.index(taskA.name)
        end
      end
    end
  end

  describe '#show(task_id)' do
    context '詳細ページにアクセスした場合' do
      example 'タスク詳細が表示される' do
        visit task_path(added_task)
        expect(page).to have_content added_task.name
        expect(page).to have_current_path task_path(added_task)
      end

      context 'ラベル表示のテスト' do
        context 'ラベル設定有のタスクを表示した場合' do
          example 'タスク詳細とラベルが表示される' do
            visit task_path(added_index_task)
            expect(page).to have_content added_index_task.name
            expect(page).to have_content test_label_A.name
            expect(page).to have_content test_label_B.name
            expect(page).to have_content test_label_C.name
            expect(page).to have_current_path task_path(added_index_task)
          end
        end

        context 'ラベル設定無のタスクを表示した場合' do
          example 'タスク詳細が表示され、ラベルは表示されない' do
            visit task_path(added_task)
            expect(page).to have_content added_task.name
            expect(page).not_to have_content test_label_A.name
            expect(page).not_to have_content test_label_B.name
            expect(page).not_to have_content test_label_C.name
            expect(page).to have_current_path task_path(added_task)
          end
        end
      end
    end
  end

  describe '#new' do
    before { visit new_task_path }
    context '必須項目を入力し、登録ボタンを押下した場合' do
      before do
        fill_in 'name', with: test_name
        fill_in 'details', with: test_details
        fill_in 'deadline', with: test_deadline
        select '中', from: 'task[priority]'
        select '着手', from: 'task[status]'
      end
      example 'タスクを登録できる' do
        click_button '登録'
        expect(page).to have_content '登録が完了しました。タスク名：' + test_name
      end
    end

    context '必須項目を入力せず、登録ボタンを押下した場合' do
      before do
        fill_in 'name', with: ''
        fill_in 'details', with: test_details
        fill_in 'deadline', with: test_deadline
        select '中', from: 'task[priority]'
        select '着手', from: 'task[status]'
      end
      example 'タスクが登録できない' do
        click_button '登録'
        expect(page).to have_content 'タスク名を入力してください'
      end
    end

    context 'ラベル登録のテスト' do
      context '必須項目を入力し、ラベルAを選択して登録した場合' do
        before do
          fill_in 'name', with: test_name
          fill_in 'details', with: test_details
          fill_in 'deadline', with: test_deadline
          select '高', from: 'task[priority]'
          select '完了', from: 'task[status]'
          check 'label_ids_1'
        end
        example 'タスクを登録できる' do
          click_button '登録'
          expect(page).to have_content '登録が完了しました。タスク名：' + test_name
        end
      end

      context '必須項目を入力せず、ラベルAを選択して登録した場合' do
        before do
          fill_in 'name', with: ''
          fill_in 'details', with: test_details
          fill_in 'deadline', with: test_deadline
          select '中', from: 'task[priority]'
          select '着手', from: 'task[status]'
          check 'label_ids_1'
        end
        example 'タスクが登録できない' do
          click_button '登録'
          expect(page).to have_content 'タスク名を入力してください'
        end
      end
    end
  end

  describe '#edit' do
    before { visit edit_task_path(added_task) }
    context '全項目を入力し、更新ボタンを押下した場合' do
      before do
        fill_in 'name', with: ''
        fill_in 'name', with: test_name
      end
      example 'タスクを更新できる' do
        click_button '更新'
        expect(page).to have_content '更新が完了しました。タスク名：' + test_name
      end
    end

    context '必須項目を入力せず、更新ボタンを押下した場合' do
      before do
        fill_in 'name', with: ''
      end
      example 'タスクを更新できない' do
        click_button '更新'
        expect(page).to have_content 'タスク名を入力してください'
      end
    end

    context 'ラベル更新のテスト' do
      context '必須項目を入力し、ラベルBを選択して更新した場合' do
        before do
          fill_in 'name', with: ''
          fill_in 'name', with: test_name
          fill_in 'details', with: test_details
          fill_in 'deadline', with: test_deadline
          select '高', from: 'task[priority]'
          select '完了', from: 'task[status]'
          check 'label_ids_2'
        end
        example 'タスクを更新できる' do
          click_button '更新'
          expect(page).to have_content '更新が完了しました。タスク名：' + test_name
        end
      end

      context '必須項目を入力し、ラベルAの選択を外して更新した場合' do
        before do
          fill_in 'name', with: ''
          fill_in 'name', with: test_name
          fill_in 'details', with: test_details
          fill_in 'deadline', with: test_deadline
          select '高', from: 'task[priority]'
          select '完了', from: 'task[status]'
          uncheck 'label_ids_1'
        end
        example 'タスクを更新できる' do
          click_button '更新'
          expect(page).to have_content '更新が完了しました。タスク名：' + test_name
        end
      end

      context '必須項目を入力せず、ラベルBを選択して更新した場合' do
        before do
          fill_in 'name', with: ''
          fill_in 'details', with: test_details
          fill_in 'deadline', with: test_deadline
          select '中', from: 'task[priority]'
          select '着手', from: 'task[status]'
          check 'label_ids_2'
        end
        example 'タスクを更新できない' do
          click_button '更新'
          expect(page).to have_content 'タスク名を入力してください'
        end
      end
    end
  end

  describe 'session' do
    before { visit root_path }
    context 'ログアウトボタンを押下した場合' do
      example 'ログアウトできる' do
        page.accept_confirm do
          click_button 'ログアウト'
        end
        expect(page).to have_content 'ログアウトしました。'
        expect(page).to have_current_path login_path
      end
    end
  end
end
