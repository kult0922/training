# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  let!(:project) { build(:project) }

  describe 'validation valid' do
    it 'pj valid' do
      expect(project).to be_valid
    end
  end

  describe 'validation invalid(project_name)' do
    before do
      project.project_name = ''
    end

    it 'pj name invalid(blank)' do
      expect(project).to be_invalid
      expect(project.errors[:project_name][0]).to eq I18n.t('projects.errors.input')
    end
  end

  describe 'validation invalid(started_at)' do
    before do
      project.started_at = ''
    end

    it 'pj started_at invalid(blank)' do
      expect(project).to be_invalid
      expect(project.errors[:started_at][0]).to eq I18n.t('projects.errors.input')
    end
  end

  describe 'validation invalid(finished_at)' do
    before do
      project.finished_at = ''
    end

    it 'pj finished_at invalid(blank)' do
      expect(project).to be_invalid
      expect(project.errors[:finished_at][0]).to eq I18n.t('projects.errors.input')
    end
  end
end
