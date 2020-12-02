require 'rails_helper'
require 'rake_helper'

RSpec.describe 'maintenance', type: :system do
  describe 'start maintenance' do
    let(:task) { Rake.application['maintenance:start'] }

    it 'run task' do
      expect(task.invoke).to be_truthy
      expect(Rails.root.join('tmp/maintenance.yml')).to exist
    end

    context 'with allowed ip' do
      it 'render login page' do
        visit root_path
        expect(page).to have_content 'ログイン'
        expect(page).to have_no_content '現在メンテナンス中です。'
      end
    end

    context 'with not allowed ip' do
      before do
        allow_any_instance_of(ActionDispatch::Request).to receive(:remote_addr).and_return('0.0.0.0')
      end
      it 'render maintenance page' do
        visit root_path
        expect(page).to have_content '現在メンテナンス中です。'
      end
    end
  end

  describe 'finish maintenance' do
    let(:task) { Rake.application['maintenance:end'] }

    it 'run task' do
      expect(task.invoke).to be_truthy
      expect(Rails.root.join('tmp/maintenance.yml')).not_to exist
    end

    it 'render login page' do
      visit root_path
      expect(page).to have_content 'ログイン'
      expect(page).to have_no_content '現在メンテナンス中です。'
    end
  end
end
