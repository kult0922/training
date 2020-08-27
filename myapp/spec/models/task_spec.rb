# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    let(:title) { 'title' }
    subject { build(:task, title: title) }

    describe 'title' do
      it { expect(subject).to be_valid }
      it { is_expected.to validate_presence_of(:title) }

      # 何故かNoMethodError: undefined method `validate_length_of' のため
      context 'when over length' do
        let(:title) { 't' * 257 }
        it { expect(subject).to be_invalid }
      end

      context 'when null' do
        let(:title) { nil }
        it { expect(subject).to be_invalid }
      end
    end
  end
  # describe 'relation' do
  # end
  # describe 'scopes' do
  # end
  # describe 'class methods' do
  # end
end
