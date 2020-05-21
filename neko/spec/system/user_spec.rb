require 'rails_helper'

describe 'user', type: :system do
  let!(:statuses) { [FactoryBot.create(:not_proceed), FactoryBot.create(:in_progress), FactoryBot.create(:done)] }
  let!(:user1) { create(:user, name: 'user1') }
  let!(:user2) { create(:user, name: 'user2') }
  let!(:user3) { create(:user, name: 'user3') }
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
    context 'a context' do
      it '' do
        visit users_path

        expect(page).to have_content 'ユーザー一覧'
        expect(page).to have_content 'タスク数'
      end
    end
  end

  describe '#new' do
    context 'a context' do
      it '' do
        visit new_user_path

        fill_in '名前', with: 'testuser4'
        fill_in 'メールアドレス', with: 'test4@example.com'
        fill_in 'パスワード', with: 'test4password'

        click_on '登録する'
        expect(page).to have_content 'ユーザーを作成しました'
      end
    end
  end

  describe '#delete (DELETE /tasks/:id)', js: true do
    context 'push delete' do
      it 'should be success to delete the user' do
        visit users_path

        # confirm dialog
        page.accept_confirm do
          click_on '削除', match: :first
        end
        expect(page).to have_content 'ユーザーを削除しました'
      end
    end
  end
end
