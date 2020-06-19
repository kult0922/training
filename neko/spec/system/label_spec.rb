require 'rails_helper'

describe 'label', type: :system do
  let!(:admin) { create(:user, name: 'admin') }
  let!(:owner) { create(:user, name: 'owner', role: 1) }
  let!(:label1) { create(:label, name: 'label1', user: admin) }
  let!(:label2) { create(:label, name: 'label2', user: owner) }

  shared_context 'login as a administrator' do
    let!(:auth1) { create(:auth, user: admin) }
    before do
      visit '/login'
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'testpassword'
      click_on 'ログイン'
    end
  end

  shared_context 'login as owner' do
    let!(:auth3) { create(:auth, user: owner, email: '12345@example.com', password: 'password') }
    before do
      visit '/login'
      fill_in 'Email', with: '12345@example.com'
      fill_in 'Password', with: 'testpassword'
      click_on 'ログイン'
    end
  end

  shared_context 'login as a general user' do
    let!(:general) { create(:user, name: 'general', role: 1) }
    let!(:auth2) { create(:auth, user: general, email: 'abcde@example.com', password: 'password') }
    before do
      visit '/login'
      fill_in 'Email', with: 'abcde@example.com'
      fill_in 'Password', with: 'password'
      click_on 'ログイン'
    end
  end

  describe "#index(GET '/labels/')" do
    context 'access labels_path' do
      include_context 'login as a administrator'
      before { visit labels_path }
      it 'should be success to access the task list' do
        expect(page).to have_current_path labels_path
        expect(page).to have_content 'ラベル一覧'
        expect(page).to have_content '名前'
        expect(page).to have_content 'タスク数'
        expect(page).to have_content '作成日時'
      end
    end
  end

  describe "#new (GET '/labels/new')" do
    include_context 'login as a administrator'
    before { visit new_label_path }
    context 'name is more than 2 letters' do
      it 'should be success to create a label' do
        expect {
          fill_in '名前', with: 'label4'
          click_on '登録する'
        }.to change(Label, :count).by(1)

        expect(page).to have_current_path labels_path
        expect(page).to have_content 'ラベルを作成しました'
      end
    end

    context 'name is less than 2 letters' do
      it 'should be failure' do
        expect {
          fill_in '名前', with: ''
          click_on '登録する'
        }.to change(Label, :count).by(0)

        expect(page).to have_content 'ラベルの作成に失敗しました'
        expect(page).to have_content '名前は2文字以上で入力してください'
      end
    end
  end

  describe "#edit (GET '/labels/:id/edit')" do
    include_context 'login as a administrator'
    before { visit edit_label_path(label1.id) }
    context 'name is more than 2 letters' do
      it 'should be success to update' do
        fill_in '名前', with: 'label5'

        click_on '更新する'
        expect(page).to have_current_path labels_path
        expect(page).to have_content 'ラベルを更新しました'
      end
    end

    context 'name is less than 2 letters' do
      it 'should be failure to update' do
        fill_in '名前', with: ''

        click_on '更新する'
        expect(page).to have_content 'ラベルの更新に失敗しました'
        expect(page).to have_content '名前は2文字以上で入力してください'
      end
    end
  end

  describe '#edit permissions' do
    context 'access edit_label_path as general user' do
      include_context 'login as a administrator'
      it 'could not access' do
        visit edit_label_path(label2.id)

        expect(page).to have_current_path edit_label_path(label2.id)
      end
    end

    context 'access edit_label_path as general user' do
      include_context 'login as a general user'
      it 'could not access' do
        visit edit_label_path(label2.id)

        expect(page).to have_current_path root_path
        expect(page).to have_content '管理者かもしくは作成者でなればアクセスできません'
      end
    end

    context 'access edit_label_path as owner' do
      include_context 'login as owner'
      it 'could not access' do
        visit edit_label_path(label2.id)

        expect(page).to have_current_path edit_label_path(label2.id)
      end
    end
  end

  describe '#delete (DELETE /labels/:id)', js: true do
    include_context 'login as a administrator'
    before { visit labels_path }
    context 'delete a general label' do
      it 'able to cancel' do
        expect {
          page.dismiss_confirm 'ラベルを削除しますか？' do
            page.all('.label-delete a')[1].click
          end
          expect(page).to have_current_path labels_path
        }.to change(Label, :count).by(0)
      end

      it 'should be success to delete' do
        expect {
          page.accept_confirm 'ラベルを削除しますか？' do
            page.all('.label-delete a')[1].click
          end
          expect(page).to have_current_path labels_path
        }.to change(Label, :count).by(-1)

        expect(page).to have_content 'ラベルを削除しました'
      end
    end
  end
end
