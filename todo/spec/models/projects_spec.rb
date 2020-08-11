# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { build(:project) }
  subject { project }

  context 'validation valid' do
    it { is_expected.to be_valid }
  end

  context 'validation invalid(project_name)' do
    it 'pj name is invalid(blank)' do
      project.project_name = ''
      is_expected.to be_invalid
      expect(project.errors.full_messages[0]).to eq 'PJ名を入力してください'
    end
  end

  context 'validation invalid(started_at)' do
    it 'pj started_at is invalid(blank)' do
      project.started_at = ''
      is_expected.to be_invalid
      expect(project.errors.full_messages[0]).to eq '開始日を入力してください'
    end
  end

  context 'validation invalid(finished_at)' do
    it 'pj finished_at invalid(blank)' do
      project.finished_at = ''
      is_expected.to be_invalid
      expect(project.errors.full_messages[0]).to eq '終了日を入力してください'
    end
  end
end
