# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    # For reuse, explicitly defined
    let(:title) { 'title' }
    let(:status) { 'open' }
    let(:user) { build(:user) }

    subject {
      build(
        :task,
        title: title,
        status: status,
        user: user,
      )
    }

    shared_examples 'subject is valid' do
      it { expect(subject).to be_valid }
    end

    describe 'title' do
      it_behaves_like 'subject is valid'
      it { is_expected.to validate_presence_of(:title) }

      context 'when over length' do
        let(:title) { 't' * 257 }
        it { expect(subject).to be_invalid }
      end
    end

    describe 'status' do
      it_behaves_like 'subject is valid'
      it { is_expected.to validate_presence_of(:status) }
    end

    describe 'user_id' do
      it_behaves_like 'subject is valid'

      context 'when user_id is nil' do
        let(:user) { nil }
        it { expect(subject).to be_invalid }
      end
    end
  end
end
