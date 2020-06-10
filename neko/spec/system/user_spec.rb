require 'rails_helper'

describe 'user', type: :system do
  let!(:user1) { create(:user, name: 'user1') }
  let!(:user2) { create(:user, name: 'user2', role: 1) }
  let!(:auth1) { create(:auth, user: user1) }
  let!(:task1) { create(:task, name: 'task1', user: user1) }
  let!(:task2) { create(:task, name: 'task2', user: user1) }
  let!(:task3) { create(:task, name: 'task3', user: user1) }
  let!(:task4) { create(:task, name: 'task4', user: user2) }

  before do
    visit '/login'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'testpassword'
    click_on 'ログイン'
  end

  describe "#index(GET '/admin/users/')" do
    context 'accress users_path' do
      it 'should be success to access the task list' do
        visit users_path

        expect(page).to have_content 'ユーザー一覧'
        expect(page).to have_content 'タスク数'
      end
    end
  end

  describe "#new (GET '/admin/users/new')" do
    context 'create new user' do
      it 'should be success' do
        visit new_user_path

        fill_in '名前', with: 'testuser4'
        fill_in 'メールアドレス', with: 'test4@example.com'
        fill_in 'パスワード', with: 'test4password'
        fill_in 'パスワード（確認用）', with: 'test4password'

        click_on '登録する'
        expect(page).to have_content 'ユーザーを作成しました'
      end
    end
  end

  describe "#new (GET '/admin/users/:id/edit')" do
    before { visit edit_user_path(user1.id) }
    context 'information is correct' do
      it 'should be success to update' do
        fill_in '名前', with: 'testuser5'
        fill_in 'メールアドレス', with: 'test5@example.com'
        fill_in 'パスワード', with: 'test5password'
        fill_in 'パスワード（確認用）', with: 'test5password'

        click_on '更新する'
        expect(page).to have_content 'ユーザーを更新しました'
      end
    end

    context 'name is blank' do
      it 'should be failure to update' do
        fill_in '名前', with: ''
        fill_in 'メールアドレス', with: 'test6@example.com'
        fill_in 'パスワード', with: 'test6password'
        fill_in 'パスワード（確認用）', with: 'test6password'

        click_on '更新する'
        expect(page).to have_content 'ユーザーの更新に失敗しました'
      end
    end

    context 'password(confirm) is wrong' do
      it 'should be failure to update' do
        fill_in '名前', with: 'testuser7'
        fill_in 'メールアドレス', with: 'test7@example.com'
        fill_in 'パスワード', with: 'test7password'
        fill_in 'パスワード（確認用）', with: 'wrongpassword'

        click_on '更新する'
        expect(page).to have_content 'ユーザーの更新に失敗しました'
      end
    end
  end

  describe '#delete (DELETE /tasks/:id)', js: true do
    context 'push delete' do
      before { visit users_path }

      it 'should be success to delete the user' do
        # confirm dialog
        page.accept_confirm do
          page.all('.user-delete a')[1].click
        end
        expect(page).to have_content 'ユーザーを削除しました'
      end

      it 'should be failure to delete the user' do
        page.accept_confirm do
          click_on '削除', match: :first
        end
        expect(page).to have_content '管理ユーザーが一人なので削除できません'
      end
    end
  end
end
