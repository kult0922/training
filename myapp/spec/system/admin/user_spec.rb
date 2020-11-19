require 'rails_helper'

RSpec.describe 'Visit admin user page', js: true, type: :system do

  context 'with admin user' do
    let!(:admin) { create(:user) }

    context 'on index' do
      let!(:member) { create(:user, role: User.roles[:member]) }

      it 'has two users' do
        visit_with_login admin_users_path, username: admin.name
        expect(page).to have_content admin.email
        expect(page).to have_content member.email
      end

    end

    context 'create user' do

      it 'with wrong password confirmation' do
        visit_with_login new_admin_user_path, username: admin.name
        fill_in I18n.t('username'), with: 'uuuuser'
        fill_in I18n.t('email'), with: 'uuuuser@myapp.com'
        fill_in I18n.t('password'), with: 'p@sSw0rD'
        fill_in I18n.t('password_confirmation'), with: 'password'
        click_button I18n.t('submit')

        expect(page).to have_content sprintf(I18n.t(
          'errors.format',
          attribute: I18n.t('activerecord.attributes.user.password_confirmation'),
          message: sprintf(I18n.t(
            'errors.messages.confirmation'),
            attribute: I18n.t('activerecord.attributes.user.password'),
          ),
        ))
      end

      it 'successfully' do
        visit_with_login new_admin_user_path, username: admin.name
        fill_in I18n.t('username'), with: 'uuuuser'
        fill_in I18n.t('email'), with: 'uuuuser@myapp.com'
        fill_in I18n.t('password'), with: 'p@sSw0rD'
        fill_in I18n.t('password_confirmation'), with: 'p@sSw0rD'
        click_button I18n.t('submit')

        expect(current_path).to match "#{admin_users_path}/#{User.find_by(name: 'uuuuser').id}"
        expect(page).to have_content I18n.t('admin.users.notice_user_created')
        expect(page).to have_field I18n.t('username'), with: 'uuuuser'
        expect(page).to have_field I18n.t('email'), with: 'uuuuser@myapp.com'
      end

    end # context 'create user'

    context 'edit user' do
      let!(:user_to_edit) { create(:user) }

      it 'successfully' do
        visit_with_login admin_user_path(user_to_edit), username: admin.name
        expect(page).to have_field I18n.t('username'), with: user_to_edit.name
        expect(page).to have_field I18n.t('email'), with: user_to_edit.email

        fill_in I18n.t('email'), with: 'user@example.com'
        click_button I18n.t('submit')

        expect(page).to have_content I18n.t('notice_updated')
        expect(page).to have_field I18n.t('email'), with: 'user@example.com'
      end
    end

    context 'delete user' do
      let!(:user_to_delete) { create(:user) }

      it 'cannot delete self' do
        visit_with_login admin_user_path(admin), username: admin.name
        expect(page).to have_no_selector(:link_or_button, I18n.t('delete'))
      end

      it 'successfully' do
        visit_with_login admin_user_path(user_to_delete), username: admin.name
        page.accept_confirm I18n.t('delete_confirm') do
          click_button(I18n.t('delete'))
        end
        expect(current_path).to eq admin_users_path
        expect(page).to have_content I18n.t('notice_deleted')
        expect(page).to have_no_content user_to_delete.email
      end

    end

  end # context 'with admin user'

  context 'with member user' do
    let(:user) { create(:user, role: User.roles[:member]) }

    it 'on index' do
      visit_with_login admin_users_path
      expect(page).to have_content 'Page Not Found'
    end

    it 'create user' do
      visit_with_login new_admin_user_path
      expect(page).to have_content 'Page Not Found'
    end

    it 'show user' do
      visit_with_login admin_user_path(user)
      expect(page).to have_content 'Page Not Found'
    end

  end

end
