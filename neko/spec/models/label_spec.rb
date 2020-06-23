require 'rails_helper'

RSpec.describe Label, type: :model do
  let(:label) { build(:label, name: label_name) }
  subject { label }

  context 'name is between 2 and 24 characters' do
    let(:label_name) { 'hoge' }
    it { is_expected.to be_valid }
  end

  context 'name is less than 2 letters' do
    let(:label_name) { '1' }
    it 'raise a error' do
      is_expected.not_to be_valid
      expect(subject.errors.full_messages).to eq ['名前は2文字以上で入力してください']
    end
  end

  context 'name is more than 24 letters' do
    let(:label_name) { 'abcdefghijklmnopqrstuvwxy' }
    it 'raise a error' do
      is_expected.not_to be_valid
      expect(subject.errors.full_messages).to eq ['名前は24文字以内で入力してください']
    end
  end

  context 'name is duplicate' do
    let!(:label_existed) { create(:label) }
    context ' & case is same' do
      let(:label_name) { label_existed.name }
      it 'raise a error' do
        is_expected.not_to be_valid
        expect(subject.errors.full_messages).to eq ['名前はすでに存在します']
      end
    end

    context '& case is different' do
      let(:label_name) { label_existed.name.upcase }
      it 'raise a error' do
        is_expected.not_to be_valid
        expect(subject.errors.full_messages).to eq ['名前はすでに存在します']
      end
    end
  end
end
