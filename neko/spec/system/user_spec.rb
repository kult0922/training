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

        expect(page).to have_current_path users_path
        expect(page).to have_content 'ユーザー一覧'
        expect(page).to have_content '名前'
        expect(page).to have_content 'ロール'
        expect(page).to have_content 'タスク数'
        expect(page).to have_content '作成日時'
      end
    end
  end

  describe "#new (GET '/admin/users/new')" do
    before { visit new_user_path }
    context 'information is correct' do
      it 'should be success to create a user' do
        expect {
          fill_in '名前', with: 'testuser1'
          fill_in 'メールアドレス', with: 'test1@example.com'
          fill_in 'パスワード', with: 'testpassword1'
          fill_in 'パスワード（確認用）', with: 'testpassword1'
          click_on '登録する'
        }.to change(User, :count).by(1)

        expect(page).to have_current_path users_path
        expect(page).to have_content 'ユーザーを作成しました'
      end
    end

    context 'name is less than 2 letters' do
      it 'should be failure to create a user' do
        expect {
          fill_in '名前', with: ''
          fill_in 'メールアドレス', with: 'test2@example.com'
          fill_in 'パスワード', with: 'testpassword2'
          fill_in 'パスワード（確認用）', with: 'testpassword2'
          click_on '登録する'
        }.to change(User, :count).by(0)

        expect(page).to have_content 'ユーザーの作成に失敗しました'
        expect(page).to have_content '名前は4文字以上で入力してください'
      end
    end

    context 'name is duplicated' do
      it 'should be failure to create a user' do
        expect {
          fill_in '名前', with: 'user1'
          fill_in 'メールアドレス', with: 'test3@example.com'
          fill_in 'パスワード', with: 'testpassword3'
          fill_in 'パスワード（確認用）', with: 'testpassword3'
          click_on '登録する'
        }.to change(User, :count).by(0)

        expect(page).to have_content 'ユーザーの作成に失敗しました'
        expect(page).to have_content '名前はすでに存在します'
      end
    end

    context 'email is blank' do
      it 'should be failure to create a user' do
        expect {
          fill_in '名前', with: 'testuser4'
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: 'testpassword4'
          fill_in 'パスワード（確認用）', with: 'testpassword4'
          click_on '登録する'
        }.to change(User, :count).by(0)

        expect(page).to have_content 'ユーザーの作成に失敗しました'
        expect(page).to have_content 'メールアドレスを入力してください'
      end
    end

    context 'email formatting is not correct' do
      it 'should be failure to create a user' do
        expect {
          fill_in '名前', with: 'testuser5'
          fill_in 'メールアドレス', with: 'abcdefghijk'
          fill_in 'パスワード', with: 'testpassword5'
          fill_in 'パスワード（確認用）', with: 'testpassword5'
          click_on '登録する'
        }.to change(User, :count).by(0)

        expect(page).to have_content 'ユーザーの作成に失敗しました'
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
    end

    context 'password(confirm) is wrong' do
      it 'should be failure to create a user' do
        expect {
          fill_in '名前', with: 'testuser6'
          fill_in 'メールアドレス', with: 'test6@example.com'
          fill_in 'パスワード', with: 'testpassword6'
          fill_in 'パスワード（確認用）', with: 'wrongpassword'
        }.to change(User, :count).by(0)

        click_on '登録する'
        expect(page).to have_content 'ユーザーの作成に失敗しました'
        expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
      end
    end
  end

  describe "#edit (GET '/admin/users/:id/edit')" do
    before { visit edit_user_path(user1.id) }
    context 'information is correct' do
      it 'should be success to update' do
        fill_in '名前', with: 'testuser7'
        fill_in 'メールアドレス', with: 'test7@example.com'
        fill_in 'パスワード', with: 'testpassword7'
        fill_in 'パスワード（確認用）', with: 'testpassword7'

        click_on '更新する'
        expect(page).to have_current_path users_path
        expect(page).to have_content 'ユーザーを更新しました'
      end
    end

    context 'name is less than 2 letters' do
      it 'should be failure to update' do
        fill_in '名前', with: ''
        fill_in 'メールアドレス', with: 'test8@example.com'
        fill_in 'パスワード', with: 'testpassword8'
        fill_in 'パスワード（確認用）', with: 'testpassword8'

        click_on '更新する'
        expect(page).to have_content 'ユーザーの更新に失敗しました'
        expect(page).to have_content '名前は4文字以上で入力してください'
      end
    end

    context 'email is blank' do
      it 'should be failure to update' do
        fill_in '名前', with: 'testuser10'
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'testpassword'
        fill_in 'パスワード（確認用）', with: 'testpassword10'

        click_on '更新する'
        expect(page).to have_content 'ユーザーの更新に失敗しました'
        expect(page).to have_content 'メールアドレスを入力してください'
      end
    end

    context 'email formatting is not correct' do
      it 'should be failure to update' do
        fill_in '名前', with: 'testuser11'
        fill_in 'メールアドレス', with: 'abcdefghijk'
        fill_in 'パスワード', with: 'testpassword11'
        fill_in 'パスワード（確認用）', with: 'testpassword11'

        click_on '更新する'
        expect(page).to have_content 'ユーザーの更新に失敗しました'
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
    end

    context 'password(confirm) is wrong' do
      it 'should be failure to update' do
        fill_in '名前', with: 'testuser12'
        fill_in 'メールアドレス', with: 'test12@example.com'
        fill_in 'パスワード', with: 'testpassword12'
        fill_in 'パスワード（確認用）', with: 'wrongpassword'

        click_on '更新する'
        expect(page).to have_content 'ユーザーの更新に失敗しました'
        expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
      end
    end

    context 'password(confirm) is wrong' do
      it 'should be failure to update' do
        fill_in '名前', with: 'testuser13'
        fill_in 'メールアドレス', with: 'test13@example.com'
        select '一般ユーザー', from: 'user_role'
        fill_in 'パスワード', with: 'testpassword13'
        fill_in 'パスワード（確認用）', with: 'testpassword13'

        click_on '更新する'
        expect(page).to have_content '管理ユーザーが1人なので更新できません'
      end
    end
  end

  describe '#delete (DELETE /users/:id)', js: true do
    before { visit users_path }

    context 'delete a general user' do
      it 'should be success to delete ' do
        expect {
          page.all('.user-delete a')[1].click
          expect(page.accept_confirm).to eq 'ユーザーを削除しますか？'
          expect(page).to have_current_path users_path
        }.to change(User, :count).by(-1)

        expect(page).to have_content 'ユーザーを削除しました'
      end
    end

    context 'delete only one administrator' do
      it 'should be failure' do
        expect {
          click_on '削除', match: :first
          expect(page.accept_confirm).to eq 'ユーザーを削除しますか？'
        }.to change(User, :count).by(0)

        expect(page).to have_current_path users_path
        expect(page).to have_content '管理ユーザーが1人なので削除できません'
      end
    end

    context 'delete current user' do
      it 'should be logout' do
        create(:user, name: 'user3')
        expect {
          click_on '削除', match: :first
          expect(page.accept_confirm).to eq 'ユーザーを削除しますか？'
          expect(page).to have_current_path login_path
        }.to change(User, :count).by(-1)

        expect(page).to have_content 'ユーザーを削除しました'
      end
    end
  end
end
