require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do
    describe 'ユーザ名' do
      subject { user }

      let!(:user) { build(:user, name: name) }

      context '入力が正しい場合' do
        let(:name) { 'test_user' }

        it { is_expected.to be_valid }
      end

      context '空欄の場合' do
        let(:name) { '' }

        it { is_expected.to be_invalid }
      end
    end

    describe 'メールアドレス' do
      subject { user }

      let!(:user) { build(:user, mail_address: mail_address) }

      context '入力が正しい場合' do
        let(:mail_address) { 'test1000000@example.com' }

        it { is_expected.to be_valid }
      end

      context '空欄の場合' do
        let(:mail_address) { '' }

        it { is_expected.to be_invalid }
      end

      context 'メールアドレスに使用できない文字列の場合' do
        let(:mail_address) { '<>!?@example.com' }

        it { is_expected.to be_invalid }
      end

      context '文字列中に「@」がない場合' do
        let(:mail_address) { 'testexample.com' }

        it { is_expected.to be_invalid }
      end

      context '既に登録済みのメールアドレスの場合' do
        let!(:userA) { create(:user) }

        let(:mail_address) { userA.mail_address }

        it { is_expected.to be_invalid }
      end
    end

    describe 'パスワード' do
      subject { user }

      let!(:user) { build(:user, password: password, password_confirmation: password_confirmation) }

      context '入力が正しい場合(半角、及、数字・英小文字、英大文字それぞれ最低１文字以上' do
        let(:password) { 'pAssw0rd' }
        let(:password_confirmation) { 'pAssw0rd' }

        it { is_expected.to be_valid }
      end

      context '空欄の場合' do
        let(:password) { '' }
        let(:password_confirmation) { '' }

        it { is_expected.to be_invalid }
      end

      context 'パスワードとパスワード確認で内容が異なる場合' do
        let(:password) { 'pAssw0rd' }
        let(:password_confirmation) { 'Passw0rd' }

        it { is_expected.to be_invalid }
      end

      context '全角英数字の場合' do
        let(:password) { 'ｐＡｓｓｗ０ｒｄ' }
        let(:password_confirmation) { 'ｐＡｓｓｗ０ｒｄ' }

        it { is_expected.to be_invalid }
      end

      context '数字のみ場合' do
        let(:password) { '12345' }
        let(:password_confirmation) { '12345' }

        it { is_expected.to be_invalid }
      end

      context '半角数字&英小文字の場合' do
        let(:password) { 'passw0rd' }
        let(:password_confirmation) { 'passw0rd' }

        it { is_expected.to be_invalid }
      end
    end
  end

  describe '削除機能' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task, user_id: user.id) }

    context 'ユーザを削除した場合' do
      it 'ユーザに紐づくタスクが削除される' do
        User.find_by(id: user.id).destroy
        expect(Task.where(user_id: user.id).size).to eq 0
      end
    end
  end
end
