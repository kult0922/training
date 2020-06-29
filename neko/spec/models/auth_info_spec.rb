require 'rails_helper'

RSpec.describe AuthInfo, type: :model do
  context 'all informations are correct' do
    subject { build(:auth, email: 'asbc@example.com', password: 'password', password_confirmation: 'password') }
    it { is_expected.to be_valid }
  end

  context 'email formatting is not correct' do
    subject { build(:auth, email: 'abcdefg12345') }
    it 'raise a error' do
      is_expected.not_to be_valid
      expect(subject.errors.full_messages).to eq ['メールアドレスは不正な値です']
    end
  end

  context 'email address entered is a duplicate' do
    subject { build(:auth, email: auth_email) }
    let!(:auth_existed) { create(:auth) }

    context '& case is same' do
      let(:auth_email) { auth_existed.email }
      it 'raise a error' do
        is_expected.not_to be_valid
        expect(subject.errors.full_messages).to eq ['メールアドレスはすでに存在します']
      end
    end

    context '& case is different' do
      let(:auth_email) { auth_existed.email.upcase }
      it 'raise a error' do
        is_expected.not_to be_valid
        expect(subject.errors.full_messages).to eq ['メールアドレスはすでに存在します']
      end
    end
  end

  context 'password-confirm is not correct' do
    subject { build(:auth, password_confirmation: 'wrongpassword') }
    it 'raise a error' do
      is_expected.not_to be_valid
      expect(subject.errors.full_messages).to eq ['パスワード（確認用）とパスワードの入力が一致しません']
    end
  end
end
