require 'rails_helper'
require 'capybara/rspec'

describe 'User', type: :feature do
  let(:user) { create(:user) }
  before do
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_on 'ログイン'
  end

  describe '#index' do
    context 'when opening admin user index' do
      it 'The screen is displayed collectly' do
        visit admin_users_path
        expect(page).to have_content I18n.t('admin.users.index.title')
        expect(page).to have_content I18n.t('activerecord.attributes.user.name')
        expect(page).to have_content I18n.t('activerecord.attributes.user.email')
        expect(page).to have_content I18n.t('activerecord.attributes.user.role')
        expect(page).to have_content I18n.t('admin.users.index.task_size')
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
        expect(page).to have_content I18n.t('activerecord.attributes.user/role.default')

        expect(page).to have_content task.title
        expect(page).to have_content task.memo
        expect(page).to have_content task.deadline.strftime('%Y/%m/%d')
        expect(page).to have_content I18n.l(task.created_at, format: :short)
        expect(page).to have_content task.human_attribute_enum(:status)
      end
    end
  end

  describe '#new' do
    context 'when creating admin user' do
      it 'user is saved' do
        visit new_admin_user_path
        fill_in User.human_attribute_name(:name), with: 'Test'
        fill_in User.human_attribute_name(:email), with: 'test@example.com'
        select I18n.t('activerecord.attributes.user/role.default'), from: User.human_attribute_name(:role)
        fill_in User.human_attribute_name(:password), with: 'password'
        fill_in User.human_attribute_name(:password_confirmation), with: 'password'

        click_button '登録する'
        expect(page).to have_content I18n.t('admin.users.flash.success', action: :作成)
      end
    end
  end

  describe '#edit' do
    context 'when editing admin user' do
      it 'user is updated' do
        visit edit_admin_user_path(user)
        fill_in User.human_attribute_name(:name), with: 'Ziro'
        fill_in User.human_attribute_name(:email), with: 'ziro@example.com'
        select I18n.t('activerecord.attributes.user/role.default'), from: User.human_attribute_name(:role)
        fill_in User.human_attribute_name(:password), with: 'password2'
        fill_in User.human_attribute_name(:password_confirmation), with: 'password2'

        click_button '更新する'
        expect(page).to have_content I18n.t('admin.users.flash.success', action: :更新)
      end
    end
  end

  describe '#delete' do
    let(:default_user) { create(:user) }
    context 'when admin user is deleted' do
      it 'redirect_to index' do
        visit admin_user_path(default_user)
        click_on I18n.t('admin.users.show.delete')
        expect(page).to have_content I18n.t('admin.users.flash.success', action: :削除)
      end
    end
    context 'when admin user is alone (ex role.size < 2 )' do
      let(:admin_user) { create(:user, role: 1) }
      it 'return error message' do
        visit admin_user_path(admin_user)
        click_on I18n.t('admin.users.show.delete')
        expect(page).to have_content I18n.t('admin.users.flash.danger', action: :削除)
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
