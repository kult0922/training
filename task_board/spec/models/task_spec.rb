require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:user) { create(:user) }
  describe 'validation' do
    let(:user) { create(:user) }
    describe 'name' do
      subject { build(:task, name: name, user_id: user.id) }

      context 'valid' do
        let(:name) { 'text' }
        it { is_expected.to be_valid }
      end

      context 'empty' do
        let(:name) { nil }
        it { is_expected.to_not be_valid }
      end

      context 'length is greater than 50' do
        let(:name) { 'a' * 51 }
        it { is_expected.to_not be_valid }
      end
    end
  end
end
