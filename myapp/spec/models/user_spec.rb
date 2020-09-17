# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    # For reuse, explicitly defined
    let(:name) { 'name' }
    let(:email) { 'test@email.us' }
    let(:password) { 'password' }

    subject {
      build(
        :user,
        name: name,
        email: email,
        password: password,
      )
    }

    shared_examples 'subject is valid' do
      it { expect(subject).to be_valid }
    end

    describe 'name' do
      it_behaves_like 'subject is valid'
      it { is_expected.to validate_presence_of(:name) }
    end

    describe 'email' do
      it_behaves_like 'subject is valid'

      it { is_expected.to validate_presence_of(:email) }

      context 'when over length' do
        let(:email) { 't' * 257 }
        it { expect(subject).to be_invalid }
      end
    end

    describe 'password' do
      it_behaves_like 'subject is valid'

      context 'when password is nil' do
        let(:password) { nil }
        it { expect(subject).to be_invalid }
      end
    end
  end
end
