require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    describe 'name presence' do
      subject { FactoryBot.build(:user, name: name) }

      context 'is valid' do
        let(:name) { 'name' }
        it { is_expected.to be_valid }
      end

      context 'is invalid' do
        let(:name) { '' }
        it { is_expected.to be_invalid }
        it 'display enter message' do
          subject.valid?
          expect(subject.errors[:name][0]).to eq I18n.t('errors.messages.blank')
        end
      end
    end

    describe 'name uniqueness' do
      subject { FactoryBot.build(:user, name: name) }
      before do
        FactoryBot.create(:user, name: 'other_name')
      end

      context 'is valid' do
        let(:name) { 'name' }
        it { is_expected.to be_valid }
      end

      context 'is invalid' do
        let(:name) { 'other_name' }
        it { is_expected.to be_invalid }
        it 'display taken message' do
          subject.valid?
          expect(subject.errors[:name][0]).to eq I18n.t('errors.messages.taken')
        end

        context 'case sensitive' do
          let(:name) { 'OTHER_NAME' }
          it { is_expected.to be_invalid }
          it 'display taken message' do
            subject.valid?
            expect(subject.errors[:name][0]).to eq I18n.t('errors.messages.taken')
          end
        end
      end
    end

    describe 'email presence' do
      subject { FactoryBot.build(:user, email: email) }

      context 'is valid' do
        let(:email) { 'test@test.com' }
        it { is_expected.to be_valid }
      end

      context 'is invalid' do
        let(:email) { '' }
        it { is_expected.to be_invalid }
        it 'display enter message' do
          subject.valid?
          expect(subject.errors[:email][0]).to eq I18n.t('errors.messages.blank')
        end
      end
    end

    describe 'email uniqueness' do
      subject { FactoryBot.build(:user, email: email) }
      before do
        FactoryBot.create(:user, email: 'other_test@test.com')
      end

      context 'is valid' do
        let(:email) { 'test@test.com' }
        it { is_expected.to be_valid }
      end

      context 'is invalid' do
        let(:email) { 'other_test@test.com' }
        it { is_expected.to be_invalid }
        it 'display taken message' do
          subject.valid?
          expect(subject.errors[:email][0]).to eq I18n.t('errors.messages.taken')
        end

        context 'case sensitive' do
          let(:email) { 'OTHER_TEST@TEST.COM' }
          it { is_expected.to be_invalid }
          it 'display taken message' do
            subject.valid?
            expect(subject.errors[:email][0]).to eq I18n.t('errors.messages.taken')
          end
        end
      end
    end

    describe 'password presence' do
      subject { FactoryBot.build(:user, password: password) }

      context 'is valid' do
        let(:password) { 'password' }
        it { is_expected.to be_valid }
      end

      context 'is invalid' do
        let(:password) { '' }
        it { is_expected.to be_invalid }
        it 'display enter message' do
          subject.valid?
          expect(subject.errors[:password][0]).to eq I18n.t('errors.messages.blank')
        end
      end
    end
  end

  describe 'tasks dependent destroy' do
    let(:user) { FactoryBot.create(:user) }
    let(:tasks) { FactoryBot.create_list(:task, 5, user: user) }

    it 'task destroyed' do
      user.destroy!
      expect(Task.count).to eq(0)
    end
  end
end
