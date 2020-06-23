require 'rails_helper'

RSpec.describe 'task', type: :system do
  let(:admin) { create(:user, name: 'admin') }
  let(:owner) { create(:user, name: 'owner', role: :general_user) }

  let!(:task1) do
    create(:task, name: 'task1', description: 'a', status: 1,
                  have_a_due: true, due_at: Time.zone.local(2020, 9, 30, 17, 30), user: admin)
  end
  let!(:task2) do
    create(:task, name: 'task2', description: 'c', status: 2,
                  have_a_due: false, due_at: Time.zone.local(2020, 7, 10, 10, 15), user: admin)
  end
  let!(:task3) do
    create(:task, name: 'task3', description: 'b', status: 0,
                  have_a_due: true, due_at: Time.zone.local(2020, 8, 15, 16, 59), user: admin)
  end
  let!(:task4) do
    create(:task, name: 'task4', description: 'e', status: 0,
                  have_a_due: true, due_at: Time.zone.local(2020, 10, 15, 11, 59), user: owner)
  end

  shared_context 'login as an administrator' do
    let!(:auth1) { create(:auth, user: admin) }
    before do
      visit '/login'
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'testpassword'
      click_on 'ログイン'
    end
  end

  shared_context 'login as owner' do
    let!(:auth2) { create(:auth, user: owner, email: '12345@example.com', password: 'password') }
    before do
      visit '/login'
      fill_in 'Email', with: '12345@example.com'
      fill_in 'Password', with: 'password'
      click_on 'ログイン'
    end
  end

  shared_context 'login as a general user' do
    let(:general) { create(:user, name: 'general', role: :general_user) }
    let!(:auth3) { create(:auth, user: general, email: 'abcde@example.com', password: 'password') }
    before do
      visit '/login'
      fill_in 'Email', with: 'abcde@example.com'
      fill_in 'Password', with: 'password'
      click_on 'ログイン'
    end
  end

  describe '#index' do
    include_context 'login as an administrator'
    before { visit tasks_path }
    context 'accress root' do
      it 'should be success to access the task list' do
        expect(page).to have_current_path tasks_path
        expect(page).to have_content 'タスク一覧'
        expect(page).to have_content '名前'
        expect(page).to have_content '説明'
        expect(page).to have_content 'ステータス'
        expect(page).to have_content 'ラベル'
        expect(page).to have_content '作成者'
        expect(page).to have_content '期限'
        expect(page).to have_content '作成日'
      end

      it 'should sorts the tasks in descending date order' do
        order = %w[task3 task2 task1]
        expect(page.all('.task-name').map(&:text)).to eq order
      end
    end

    context 'click item name' do
      it 'reorders the tasks based on items' do
        test_cases = [
          { button: '名前', order: %w[task3 task2 task1] },
          { button: '説明', order: %w[task2 task3 task1] },
          { button: '作成日', order: %w[task3 task2 task1] },
          { button: '期限', order: %w[task1 task3 task2], order2: %w[task3 task1 task2] },
          { button: 'ステータス', order: %w[task2 task1 task3] }
        ]

        test_cases.each do |test_case|
          click_on test_case[:button]
          expect(page.all('.task-name').map(&:text)).to eq test_case[:order]

          click_on test_case[:button]
          test_case[:order2] = test_case[:order].reverse if test_case[:order2].nil?
          expect(page.all('.task-name').map(&:text)).to eq test_case[:order2]
        end
      end
    end

    context 'click item name' do
      it 'reorders the tasks based on items' do
        test_cases = %w[未着手 着手中 完了]
        test_cases.each do |test_case|
          select(test_case, from: 'status')
          click_on '検索'

          page.all('.task-status').map(&:text).each do |s|
            expect(s).to eq test_case
          end
        end
      end
    end
  end

  describe '#new (GET /tasks/new)' do
    include_context 'login as an administrator'
    before { visit new_task_path }
    context 'name is more than 2 letters' do
      it 'should be success to create a task' do
        expect {
          fill_in '名前', with: 'hoge'
          fill_in '説明', with: 'fuga'
          click_on '登録する'
        }.to change(Task, :count).by(1)

        expect(page).to have_current_path tasks_path
        expect(page).to have_content 'タスクを作成しました'
      end
    end

    context 'name is less than 2 letters' do
      it 'should be failure to create a task' do
        expect {
          fill_in '名前', with: ''
          fill_in '説明', with: 'piyo'
          click_on '登録する'
        }.to change(Task, :count).by(0)

        expect(page).to have_content 'タスクの作成に失敗しました'
        expect(page).to have_content '名前は2文字以上で入力してください'
      end
    end
  end

  describe '#show (GET /tasks/:id)' do
    context 'access edit_task_path as administrator' do
      include_context 'login as an administrator'
      it 'could not access' do
        visit task_path(task4.id)

        expect(page).to have_current_path task_path(task4.id)
        expect(page).to have_content 'task4'
        expect(page).to have_content 'e'
        expect(page).to have_content '未着手'
        expect(page).to have_content '2020/10/15 11:59'
        expect(page).to have_content 'owner'
      end
    end

    context 'access edit_task_path as owner' do
      include_context 'login as owner'
      it 'could not access' do
        visit task_path(task4.id)

        expect(page).to have_current_path task_path(task4.id)
      end
    end

    context 'access edit_task_path as general user' do
      include_context 'login as a general user'
      it 'could not access' do
        visit task_path(task4.id)

        expect(page).to have_current_path root_path
        expect(page).to have_content '管理者かもしくは作成者でなればアクセスできません'
      end
    end
  end

  describe '#edit (GET /tasks/:id/edit)' do
    include_context 'login as an administrator'
    before { visit edit_task_path(task1.id) }
    context 'name is more than 2 letters' do
      it 'should be success to update' do
        fill_in '名前', with: 'hogehoge'
        fill_in '説明', with: 'fugaguga'

        click_on '更新する'
        expect(page).to have_current_path task_path(task1.id)
        expect(page).to have_content 'タスクを更新しました'
      end
    end

    context 'name is blank' do
      it 'should be failure to update' do
        fill_in '名前', with: ''
        fill_in '説明', with: 'piyopiyo'

        click_on '更新する'
        expect(page).to have_current_path task_path(task1.id)
        expect(page).to have_content 'タスクの更新に失敗しました'
        expect(page).to have_content '名前は2文字以上で入力してください'
      end
    end
  end

  describe '#edit permissions' do
    context 'access edit_task_path as general user' do
      include_context 'login as an administrator'
      it 'could not access' do
        visit edit_task_path(task4.id)

        expect(page).to have_current_path edit_task_path(task4.id)
      end
    end

    context 'access edit_task_path as general user' do
      include_context 'login as a general user'
      it 'could not access' do
        visit edit_task_path(task4.id)

        expect(page).to have_current_path root_path
        expect(page).to have_content '管理者かもしくは作成者でなればアクセスできません'
      end
    end

    context 'access edit_task_path as owner' do
      include_context 'login as owner'
      it 'could not access' do
        visit edit_task_path(task4.id)

        expect(page).to have_current_path edit_task_path(task4.id)
      end
    end
  end

  describe '#delete (DELETE /tasks/:id)', js: true do
    include_context 'login as an administrator'
    before { visit task_path(task1.id) }
    context 'delete a general label' do
      it 'able to cancel' do
        expect {
          click_on '削除'
          expect(page.dismiss_confirm).to eq 'タスクを削除しますか？'
          expect(page).to have_current_path task_path(task1.id)
        }.to change(Task, :count).by(0)
      end

      it 'should be success to delete' do
        expect {
          click_on '削除'
          expect(page.accept_confirm).to eq 'タスクを削除しますか？'
          expect(page).to have_current_path tasks_path
        }.to change(Task, :count).by(-1)

        expect(page).to have_content 'タスクを削除しました'
      end
    end
  end
end
