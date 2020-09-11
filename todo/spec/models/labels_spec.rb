# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  let(:label) { build(:label) }
  subject { label }

  context 'validation valid' do
    it { is_expected.to be_valid }
  end

  context 'when color is invalid' do
    it 'should be color invalid error' do
      label.color = ''
      is_expected.to be_invalid
      expect(label.errors.full_messages[0]).to eq '色を入力してください'
      expect(label.errors.full_messages[1]).to eq '色は不正な値です'
    end
  end

  context 'when text is invalid' do
    it 'should be text invaild error' do
      label.text = ''
      is_expected.to be_invalid
      expect(label.errors.full_messages[0]).to eq 'ラベル内容を入力してください'
    end
  end
end
