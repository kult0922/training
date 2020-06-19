require 'rails_helper'

RSpec.describe Label, type: :model do
  context 'name is between 2 and 24 characters' do
    let!(:label) { build(:label, name: 'hoge') }
    it 'should be OK' do
      expect(label).to be_valid
    end
  end

  context 'name is less than 2 letters' do
    let!(:label) { build(:label, name: '1') }
    it 'raise a error' do
      expect(label.valid?).to eq false
      expect(label.errors.full_messages).to eq ['名前は2文字以上で入力してください']
    end
  end

  context 'name is more than 24 letters' do
    let!(:label) { build(:label, name: 'abcdefghijklmnopqrstuvwxy') }
    it 'raise a error' do
      expect(label.valid?).to eq false
      expect(label.errors.full_messages).to eq ['名前は24文字以内で入力してください']
    end
  end

  context 'name is duplicate' do
    let!(:label) { create(:label, name: 'label') }
    context ' & case is same' do
      let!(:duplicate_label) { build(:label, name: label.name) }
      it 'raise a error' do
        expect(duplicate_label.valid?).to eq false
        expect(duplicate_label.errors.full_messages).to eq ['名前はすでに存在します']
      end
    end

    context '& case is different' do
      let!(:duplicate_label) { build(:label, name: label.name.upcase) }
      it 'raise a error' do
        expect(duplicate_label.valid?).to eq false
        expect(duplicate_label.errors.full_messages).to eq ['名前はすでに存在します']
      end
    end
  end
end
