require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    context 'when name is nil' do
      let(:user) { build(:user, name: '') }
      it 'raise nil error' do
        expect(user).to be_invalid
      end
    end

    context 'when email is nil' do
      let(:user) { build(:user, email: '') }
      it 'raise nil error' do
        expect(user).to be_invalid
      end
    end

    context 'when email is same word' do
      let!(:user) { create(:user, email: 'test@example.com') }
      let(:user2) { build(:user, email: 'test@example.com') }
      it 'raise unique error' do
        expect(user2).to be_invalid
      end
    end

    context 'when not allowed sentence is entered in the email' do
      let(:user) { build(:user, email: 'test') }
      it 'raise format error' do
        expect(user).to be_invalid
      end
    end

    context 'when password is nil' do
      let(:user) { build(:user, password: '') }
      it 'rails nil error' do
        expect(user).to be_invalid
      end
    end

    context 'when role is nil' do
      let(:user) { build(:user, role: '') }
      it 'rails nil error' do
        expect(user).to be_invalid
      end
    end

  describe 'Association' do
    let(:association) { User.reflect_on_association(terget) }
    context 'when checking task association' do
      let(:terget) { :tasks }
      it 'return has_many association' do
        expect(association.macro).to eq :has_many
      end
    end
  end

  end
end
