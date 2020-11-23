require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'validation' do
    describe 'name' do
      let!(:user) { create(:user) }
      subject { build(:label, name: name, user_id: user.id) }

      context 'valid' do
        let(:name) { 'test_label' }
        it { is_expected.to be_valid }
      end

      context 'empty' do
        let(:name) { nil }
        it { is_expected.to_not be_valid }
      end

      context 'length is greater than 30' do
        let(:name) { 'a' * 31 }
        it { is_expected.to_not be_valid }
      end

      context 'duplicated name' do
        let!(:label_sample) { create(:label, user_id: user.id) }
        let(:name) { label_sample.name }
        it { is_expected.to_not be_valid }
      end
    end
  end
end
