require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user, name: user_name) }
  subject { user } 

  context 'name is between 4 and 15 characters' do
    let(:user_name) { 'user' }
    it { is_expected.to be_valid }
  end

  context 'name is less than 4 letters' do
    let(:user_name) { 'abc' }
    it 'raise a error' do
      is_expected.not_to be_valid
      expect(subject.errors.full_messages).to eq ['名前は4文字以上で入力してください']
    end
  end

  context 'name is less than 15 letters' do
    let(:user_name) { '0123456789abcdef' }
    it 'raise a error' do
      is_expected.not_to be_valid
      expect(subject.errors.full_messages).to eq ['名前は15文字以内で入力してください']
    end
  end

  context 'name is duplicate' do
    let!(:user_existed) { create(:user) }
    context '& case is same' do
      let(:user_name) { user_existed.name }
      it 'raise a error' do
        is_expected.not_to be_valid
        expect(subject.errors.full_messages).to eq ['名前はすでに存在します']
      end
    end

    context '& case is different' do
      let(:user_name) { user_existed.name.upcase }
      it 'raise a error' do
        is_expected.not_to be_valid
        expect(subject.errors.full_messages).to eq ['名前はすでに存在します']
      end
    end
  end
end
