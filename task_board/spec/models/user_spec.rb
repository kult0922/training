require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    let(:name) { 'test' }
    let(:email) { 'test@test.com' }
    let(:password) { 'password' }
    let(:password_confirmation) { 'password' }
    let(:role) { :basic }

    subject do
      build(
        :user,
        name: name,
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        role: role
      )
    end

    describe 'valid' do
      it { is_expected.to be_valid }
    end

    describe 'invalid' do
      context 'name' do
        context 'empty string' do
          let(:name) { '' }
          it { is_expected.to_not be_valid }
        end

        context 'greater than 25 length' do
          let(:name) { 'a' * 26 }
          it { is_expected.to_not be_valid }
        end
      end

      context 'email' do
        context 'empty string' do
          let(:email) { '' }
          it { is_expected.to_not be_valid }
        end

        context 'duplicated' do
          let!(:test_user) { create(:user) }
          let(:email) { test_user.email }
          it { is_expected.to_not be_valid }
        end
      end

      context 'password' do
        context 'password_confirmation does not match' do
          let(:password_confirmation) { 'wrong_password' }
          it { is_expected.to_not be_valid }
        end
      end
    end
  end
end
