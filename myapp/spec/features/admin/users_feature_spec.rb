require 'rails_helper'
require 'capybara/rspec'

describe 'User', type: :feature do
  let(:user) { create(:user, role: 1) }
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
      end
    end
  end

  describe '#show' do
    context 'when opening admin user show' do
      it 'returns user' do
        visit admin_user_path(user)
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content I18n.t('activerecord.attributes.user/role.admin')
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
    context 'when admin user is deleted' do
      it 'redirect_to index' do
        visit admin_user_path(user)
        click_on I18n.t('admin.users.show.delete')
        expect(page).to have_content I18n.t('admin.users.flash.success', action: :削除)
      end
    end
  end
end
