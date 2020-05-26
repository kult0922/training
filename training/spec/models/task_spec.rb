require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    describe 'title' do
      subject { FactoryBot.build(:task, title: title) }
      context 'valid' do
        context 'title is 49 characters' do
          let(:title) { 'a' * 49 }
          it { is_expected.to be_valid }
        end

        context 'title is 50 characters' do
          let(:title) { 'a' * 50 }
          it { is_expected.to be_valid }
        end
      end

      context 'invalid' do
        context 'title is blank' do
          let(:title) { '' }
          it { is_expected.to be_invalid }
        end
        context 'title is 51 characters' do
          let(:title) { 'a' * 51 }
          it { is_expected.to be_invalid }
        end
      end
    end

    describe 'priority' do
      subject { FactoryBot.build(:task, priority: priority) }
      context 'valid' do
        context 'title is present' do
          let(:priority) { 'low' }
          it { is_expected.to be_valid }
        end
      end

      context 'invalid' do
        context 'title is blank' do
          let(:priority) { '' }
          it { is_expected.to be_invalid }
        end
      end
    end

    describe 'status' do
      subject { FactoryBot.build(:task, status: status) }
      context 'valid' do
        context 'title is present' do
          let(:status) { 'waiting' }
          it { is_expected.to be_valid }
        end
      end

      context 'invalid' do
        context 'title is blank' do
          let(:status) { '' }
          it { is_expected.to be_invalid }
        end
      end
    end

    describe 'due_date' do
      subject { FactoryBot.build(:task, due_date: due_date) }
      context 'valid' do
        context 'due_date is blank' do
          let(:due_date) { '' }
          it { is_expected.to be_valid }
        end

        context 'due_date is future' do
          let(:due_date) { Time.now + 1.day }
          it { is_expected.to be_valid }
        end
      end

      context 'invalid' do
        context 'due_date is past' do
          let(:due_date) { Time.now - 1.day }
          it { is_expected.to be_invalid }
        end
      end
    end
  end
end
