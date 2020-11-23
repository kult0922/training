require 'rails_helper'

RSpec.describe Label, type: :system do
  let!(:user) { create(:user) }
  let!(:label) { create(:label, user_id: user.id) }

  before do
    visit login_path
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password
    click_button 'ログイン'
  end

  describe '#index' do
    it 'visit index page' do
      visit root_path
      expect(page).to have_content label.name
    end
  end

  describe '#new' do
    before { visit new_label_path }
    context 'with valid form' do
      let(:label_name) { 'label1'}
      before do
        fill_in 'label_name', with: label_name
      end

      it 'success to create label' do
        click_button '保存'
        expect(current_path).to eq labels_path
        expect(page).to have_content "ラベル「#{label_name}」を登録しました。"
      end
    end

    context 'with invalid form' do
      before do
        fill_in 'label_name', with: 'a' * 31
      end
      it 'fail to create label' do
        click_button '保存'
        expect(page).to have_content 'ラベル名は30文字以内で入力してください'
      end
    end

    describe '#destroy' do
      before { visit labels_path }
      it 'destroy label' do
        click_button '削除', match: :first
        expect(page.driver.browser.switch_to.alert.text).to eq "ラベル：「#{label.name}」、本当に削除しますか？"
        expect { page.driver.browser.switch_to.alert.accept }.to change { Label.count }.by(0)
        expect(page).to have_content "ラベル「#{label.name}」を削除しました。"
      end
    end
  end
end
