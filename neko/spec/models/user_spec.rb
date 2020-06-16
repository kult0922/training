require 'rails_helper'

RSpec.describe User, type: :model do
  context 'name is between 4 and 15 characters' do
    it 'should be success' do
      user = User.new(name: 'user')
      expect(user).to be_valid
    end
  end

  context 'name is less than 4 letters' do
    it 'should be failure' do
      user = User.new(name: 'abc')
      expect(user.valid?).to eq false
      expect(user.errors.full_messages).to eq ['名前は4文字以上で入力してください']
    end
  end

  context 'name is less than 15 letters' do
    it 'should be failure' do
      user = User.new(name: '0123456789abcdef')
      expect(user.valid?).to eq false
      expect(user.errors.full_messages).to eq ['名前は15文字以内で入力してください']
    end
  end

  context 'name is duplicate (case-insensitive）' do
    it 'should be failure' do
      user = User.create!(name: 'user')
      duplicate_user = User.new(name: user.name.upcase)
      expect(duplicate_user.valid?).to eq false
      expect(duplicate_user.errors.full_messages).to eq ['名前はすでに存在します']
    end
  end
end
