# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { create(:user) }

  describe '#new' do
    before { visit new_user_path }
    context 'when user name is not input' do
      it 'should be validation error' do
        fill_in 'user_account_name', with: ''
        fill_in 'user_password', with: ''
        click_on '登録する'

        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(page).to have_content 'ユーザ名は英数字のみが使えます'
      end
    end

    context 'when user name is duplicate' do
      it 'should be validation error' do
        fill_in 'user_account_name', with: user.account_name
        fill_in 'user_password', with: 'testtest'
        click_on '登録する'

        expect(page).to have_content 'ユーザ名はすでに存在します'
      end
    end

    context 'when user create' do
      it 'should be created user' do
        fill_in 'user_account_name', with: 'TestUser1'
        fill_in 'user_password', with: 'testtest'
        click_on '登録する'

        expect(page).to have_content 'ユーザが作成されました。'
      end
    end
  end

  describe '#edit' do
    before do
      login(user)
      visit edit_user_path(user)
    end
    context 'when user edit' do
      it 'should be update user' do
        fill_in 'user_account_name', with: 'updateuser1'
        fill_in 'user_password', with: 'testtest'
        click_on '更新する'

        expect(page).to have_content 'ユーザが更新されました。'
      end
    end
  end

  describe '#admin/user/index' do
    let!(:admin_user) { create(:user, admin: 'true') }

    context 'when admin user access page' do
      it 'move admin page' do
        login(admin_user)
        visit admin_users_path
        expect(page).to have_content '管理者専用ページ'
        expect(page).to have_content '管理者権限'
        expect(page).to have_content '担当者タスク数'
        expect(page).to have_content '承認者タスク数'
        expect(page).to have_content '作成日'
        expect(page).to have_content '更新日'
        expect(page).to have_content 'factoryUser3'
        expect(page).to have_content 'true'
      end

      it 'should have tasks' do
        create(:task, assignee_id: admin_user.id, reporter_id: admin_user.id)
        create(:task, assignee_id: user.id, reporter_id: admin_user.id)

        login(admin_user)
        visit admin_users_path
        expect(page).to have_content '1'
        expect(page).to have_content '2'
      end
    end

    context 'when user is not have admin auth' do
      it 'move project page' do
        login(user)
        visit admin_users_path
        expect(page).to have_content 'PJ登録'
      end
    end
  end

  describe '#admin/user/show' do
    let!(:admin_user) { create(:user, admin: 'true') }

    before do
      login(admin_user)
    end

    context 'when user tasks access page' do
      let!(:task) { create(:task, assignee_id: admin_user.id, reporter_id: admin_user.id) }

      it 'should be visible tasks' do
        visit admin_user_path(admin_user)
        expect(page).to have_content 'PJ_Factory'
        expect(page).to have_content '高'
        expect(page).to have_content '未着手'
        expect(page).to have_content '2020-10-05'
      end
    end
  end

  describe '#admin/user/new' do
    let!(:admin_user) { create(:user, admin: 'true') }

    before do
      login(admin_user)
      visit new_admin_user_path
    end

    context 'when user name is not input' do
      it 'should be validation error' do
        fill_in 'user_account_name', with: ''
        fill_in 'user_password', with: ''
        click_on '登録する'

        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(page).to have_content 'ユーザ名は英数字のみが使えます'
      end
    end

    context 'when user name is duplicate' do
      it 'should be validation error' do
        fill_in 'user_account_name', with: user.account_name
        fill_in 'user_password', with: 'testtest'
        click_on '登録する'

        expect(page).to have_content 'ユーザ名はすでに存在します'
      end
    end

    context 'when user create' do
      it 'should be created user' do
        fill_in 'user_account_name', with: 'TestUser1'
        fill_in 'user_password', with: 'testtest'
        click_on '登録する'

        expect(page).to have_content 'ユーザが作成されました。'
      end
    end
  end

  describe '#admin/user/edit' do
    let!(:admin_user) { create(:user, admin: 'true') }

    before do
      login(admin_user)
      visit edit_admin_user_path(user)
    end

    context 'when user edit' do
      it 'should be update user' do
        fill_in 'user_account_name', with: 'updateuser1'
        fill_in 'user_password', with: 'testtest'
        click_on '更新する'

        expect(page).to have_content 'ユーザが更新されました。'
      end
    end
  end

  describe '#admin/user/delete' do
    let!(:admin_user) { create(:user, admin: 'true') }

    before do
      login(admin_user)
      visit admin_users_path(user)
    end

    context 'when user delete' do
      it 'should be deleted' do
        click_link '削除', href: admin_user_path(user)
        expect(page.driver.browser.switch_to.alert.text).to eq '削除してもよろしいでしょうか?'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'ユーザが削除されました。'
      end
    end
  end
end
