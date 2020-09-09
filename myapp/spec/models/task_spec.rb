# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    # For reuse, explicitly defined
    let(:title) { 'title' }
    let(:status) { 'open' }
    subject { build(:task, title: title, status: status) }

    describe 'title' do
      it { expect(subject).to be_valid }
      it { is_expected.to validate_presence_of(:title) }

      # 何故かNoMethodError: undefined method 'validate_length_of' のため
      context 'when over length' do
        let(:title) { 't' * 257 }
        it { expect(subject).to be_invalid }
      end
    end

    describe 'status' do
      it { expect(subject).to be_valid }
      it { is_expected.to validate_presence_of(:status) }
    end
  end
end
