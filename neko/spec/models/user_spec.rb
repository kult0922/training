require 'rails_helper'

RSpec.describe User, type: :model do
  context 'name is between 4 and 15 characters' do
    let!(:user) { build(:user, name: 'user') }
    it 'should be OK' do
      expect(user).to be_valid
    end
  end

  context 'name is less than 4 letters' do
    let!(:user) { build(:user, name: 'abc') }
    it 'raise a error' do
      expect(user.valid?).to eq false
      expect(user.errors.full_messages).to eq ['名前は4文字以上で入力してください']
    end
  end

  context 'name is less than 15 letters' do
    let!(:user) { build(:user, name: '0123456789abcdef') }
    it 'raise a error' do
      expect(user.valid?).to eq false
      expect(user.errors.full_messages).to eq ['名前は15文字以内で入力してください']
    end
  end

  context 'name is duplicate' do
    let!(:user) { create(:user, name: 'user') }
    context '& case is same' do
      let!(:duplicate_user) { build(:user, name: user.name) }
      it 'raise a error' do
        expect(duplicate_user.valid?).to eq false
        expect(duplicate_user.errors.full_messages).to eq ['名前はすでに存在します']
      end
    end

    context '& case is different' do
      let!(:duplicate_user) { build(:user, name: user.name.upcase) }
      it 'raise a error' do
        expect(duplicate_user.valid?).to eq false
        expect(duplicate_user.errors.full_messages).to eq ['名前はすでに存在します']
      end
    end
  end
end
