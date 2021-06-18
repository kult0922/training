require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#valid?' do
    subject { build(:task, params) }
    let(:params) { { title: title, description: description } }
    let(:random_str) { Faker::Alphanumeric.alphanumeric(number: 10) }

    context 'valid' do
      let(:title) { random_str }
      let(:description) { random_str }

      it { is_expected.to be_valid }
    end

    context 'invalid title' do
      let(:title) { nil }
      let(:description) { random_str }

      it { is_expected.to_not be_valid }
    end
    context 'invalid description' do
      let(:title) { random_str }
      let(:description) { nil }

      it { is_expected.to_not be_valid }
    end
  end
end
