require 'rails_helper'
require 'capybara/rspec'

describe 'Label', type: :feature do
  let(:user) { create(:user, role: 1) }
  let!(:label1) { create(:label) }
  let!(:label2) { create(:label, name: 'red') }
  let!(:label3) { create(:label, name: 'blue') }

  before do
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_on 'ログイン'
  end

  describe '#index' do
    context 'when opening label index' do
      it 'The screen is displayed collectly' do
        visit labels_path
        expect(page).to have_content 'ラベル一覧'
        expect(page).to have_content 'ラベル名'

        expect(page).to have_content label1.name
        expect(page).to have_content label2.name
        expect(page).to have_content label3.name
      end
    end
  end

  describe '#show' do
    context 'when opening label show' do
      it 'returns label' do
        visit label_path(label1)
        expect(page).to have_content label1.name
      end
    end
  end

  describe '#new' do
    context 'when creating label' do
      it 'label is saved' do
        visit new_label_path
        fill_in 'ラベル名', with: 'green'

        click_button '登録する'
        expect(page).to have_content 'ラベルの作成に成功しました'
      end
    end
  end

  describe '#edit' do
    context 'when editing label' do
      it 'label is updated' do
        visit edit_label_path(label1)
        fill_in 'ラベル名', with: 'green'
        click_button '更新する'
        expect(page).to have_content 'ラベルの更新に成功しました'
        expect(page).to have_content 'green'
      end
    end
  end

  describe '#destroy' do
    context 'when label is deleted' do
      it 'redirect_to index' do
        visit label_path(label1)
        click_on '削除'
        expect(page).to have_content 'ラベルの削除に成功しました'

        expect(page).to have_no_content label1.name
      end
    end
  end
end
