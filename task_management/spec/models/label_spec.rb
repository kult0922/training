require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'バリデーション' do
    describe ' ラベル名' do
      subject { label }

      let!(:user) { create(:user) }
      let!(:label) { build(:label, name: name, user_id: user.id) }

      context '入力が正しい場合' do
        let(:name) { 'label' }

        it { is_expected.to be_valid }
      end

      context '空欄の場合' do
        let(:name) { '' }

        it { is_expected.to be_invalid }
      end

      context '文字数の最大値の場合' do
        let(:name) { 'a' * 10 }

        it { is_expected.to be_valid }
      end

      context '文字数の最大値を超過した場合' do
        let(:name) { 'a' * 11 }

        it { is_expected.to be_invalid }
      end
    end
  end
end
