require 'rails_helper'
require 'capybara/rspec'

describe 'User', type: :feature do
  let(:user) { create(:user, role: 1) }
  before do
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_on I18n.t('sessions.new.login')
  end

  describe '#index' do
    let!(:tasks) { create_list(:task, 5, user: user) }
    context 'when opening admin user index' do
      it 'The screen is displayed collectly' do
        visit admin_users_path
        expect(page).to have_content 'ユーザー一覧'
        expect(page).to have_content 'ユーザー名'
        expect(page).to have_content 'メールアドレス'
        expect(page).to have_content '役割'
        expect(page).to have_content 'タスク数'

        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content '管理ユーザー'
        expect(page).to have_content tasks.size
      end
    end
  end

  describe '#show' do
    let!(:task) { create(:task, user: user) }
    context 'when opening admin user show' do
      it 'returns user and tasks' do
        visit admin_user_path(user)
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content '管理ユーザー'

        expect(page).to have_content task.title
        expect(page).to have_content task.memo
        expect(page).to have_content task.deadline.strftime('%Y/%m/%d')
        expect(page).to have_content task.created_at.strftime('%m/%d %R')
        expect(page).to have_content task.human_attribute_enum(:status)
      end
    end
  end

  describe '#new' do
    context 'when creating admin user' do
      it 'user is saved' do
        visit new_admin_user_path
        fill_in 'ユーザー名', with: 'Test'
        fill_in 'メールアドレス', with: 'test@example.com'
        select '一般ユーザー', from: '役割'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'

        click_button '登録する'
        expect(page).to have_content 'ユーザーの作成に成功しました'
      end
    end
  end

  describe '#edit' do
    context 'when editing admin user' do
      it 'user is updated' do
        visit edit_admin_user_path(user)
        fill_in 'ユーザー名', with: 'Ziro'
        fill_in 'メールアドレス', with: 'ziro@example.com'
        select '一般ユーザー', from: '役割'
        fill_in 'パスワード', with: 'password2'
        fill_in 'パスワード（確認用）', with: 'password2'

        click_button '更新する'
        expect(page).to have_content 'ユーザーの更新に成功しました'
        expect(page).to have_content 'Ziro'
        expect(page).to have_content 'ziro@example.com'
        expect(page).to have_content '一般ユーザー'
      end
    end
  end

  describe '#destroy' do
    let(:user2) { create(:user, name: 'Ziro') }
    context 'when admin user is deleted' do
      it 'redirect_to index' do
        visit admin_user_path(user2)
        click_on '削除'
        expect(page).to have_content 'ユーザーの削除に成功しました'

        expect(page).to have_no_content user2.name
        expect(page).to have_no_content user2.email
      end
    end
    context 'when admin user is alone (ex role.size < 2 )' do
      it 'return error message' do
        visit admin_user_path(user)
        click_on I18n.t('admin.users.show.delete')
        expect(page).to have_content I18n.t('admin.users.flash.danger', action: :削除)
      end
    end
  end

  describe 'check admin user when showing admin user page', :skip_before do
    context 'when user is default' do
      let(:default_user) { create(:user) }
      it 'dont show admin user button' do
        visit login_path
        fill_in 'email', with: default_user.email
        fill_in 'password', with: default_user.password
        click_on I18n.t('sessions.new.login')
        expect(page).to have_no_content I18n.t('tasks.index.admin_user')
      end
      it 'return tasks page' do
        visit login_path
        fill_in 'email', with: default_user.email
        fill_in 'password', with: default_user.password
        click_on I18n.t('sessions.new.login')
        visit admin_users_path
        expect(page).to have_no_content I18n.t('admin.users.index.title')
      end
    end
  end

  describe 'paginate' do
    let!(:users) { create_list(:user, 19) }
    context 'when 2 button clicked' do
      it 'show 5 to 10 task' do
        visit admin_users_path
        click_on '2'
        expect(page).to have_content users[4].email
        expect(page).to have_content users[8].email
      end
    end
    context 'when end button clicked' do
      it 'show 16 to 20 task' do
        visit admin_users_path
        click_on '最後'
        expect(page).to have_content users[14].email
        expect(page).to have_content users[18].email
      end
    end
  end
end
