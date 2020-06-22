require 'rails_helper'

RSpec.describe AuthInfo, type: :model do
  context 'all informations are correct' do
    let(:auth) { build(:auth, email: 'asbc@example.com', password: 'password', password_confirmation: 'password') }
    it 'should be OK' do
      expect(auth).to be_valid
    end
  end

  context 'email formatting is not correct' do
    let(:auth) { build(:auth, email: 'abcdefg12345') }
    it 'raise a error' do
      expect(auth.valid?).to eq false
      expect(auth.errors.full_messages).to eq ['メールアドレスは不正な値です']
    end
  end

  context 'email address entered is a duplicate' do
    let!(:auth) { create(:auth) }
    context '& case is same' do
      let(:duplicate_auth) { build(:auth, email: auth.email) }
      it 'raise a error' do
        expect(duplicate_auth.valid?).to eq false
        expect(duplicate_auth.errors.full_messages).to eq ['メールアドレスはすでに存在します']
      end
    end

    context '& case is different' do
      let(:duplicate_auth) { build(:auth, email: auth.email.upcase) }
      it 'raise a error' do
        expect(duplicate_auth.valid?).to eq false
        expect(duplicate_auth.errors.full_messages).to eq ['メールアドレスはすでに存在します']
      end
    end
  end

  context 'password-confirm is not correct' do
    let(:auth) { build(:auth, password_confirmation: 'wrongpassword') }
    it 'raise a error' do
      expect(auth.valid?).to eq false
      expect(auth.errors.full_messages).to eq ['パスワード（確認用）とパスワードの入力が一致しません']
    end
  end
end
