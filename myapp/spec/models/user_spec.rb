require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    # For reuse, explicitly defined
    let(:name) { 'name' }
    let(:email) { 'test@email.us' }
    subject { build(:user, name: name, email: email) }

    describe 'name' do
      it { expect(subject).to be_valid }
      it { is_expected.to validate_presence_of(:name) }
    end

    describe 'email' do
      it { expect(subject).to be_valid }
      it { is_expected.to validate_presence_of(:email) }

      context 'when over length' do
        let(:email) { 't' * 257 }
        it { expect(subject).to be_invalid }
      end
    end
  end
end
