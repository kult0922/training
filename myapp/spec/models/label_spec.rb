require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    context 'when name is nil' do
      let(:label) { build(:label, name: '') }
      it 'raise nil error' do
        expect(label).to be_invalid
      end
    end
    context 'when name is same' do
      let!(:label1) { create(:label) }
      let(:label2) { build(:label) }
      it 'raise unique error' do
        expect(label2).to be_invalid
      end
    end
  end
end
