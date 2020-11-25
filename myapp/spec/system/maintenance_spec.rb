require 'rake_helper'

RSpec.describe 'maintenance', js: true, type: :system do

  describe 'start' do
    let!(:task) { Rake.application['maintenance:start'] }

    context 'ip not allowed' do
      before :each do
        allow_any_instance_of(MaintenanceHelper).to receive(:restart_server) do
          Rails.application.config.x.maintenance.enable = true
          Rails.application.config.x.maintenance.allow_ips = []
        end
      end

      it 'executed' do
        expect(task.invoke).to be_truthy
        expect(Rails.root.join('tmp/maintenance.yml')).to exist
      end

      it 'cannot visit' do
        visit root_path
        expect(page).to have_content 'Service Unavailable'
      end
    end

    context 'ip allowed' do
      before :each do
        allow_any_instance_of(MaintenanceHelper).to receive(:restart_server) do
          Rails.application.config.x.maintenance.enable = true
          Rails.application.config.x.maintenance.allow_ips = ['127.0.0.1']
        end
      end

      it 'maintenance.yml in tmp' do
        expect(task.invoke).to be_truthy
        expect(Rails.root.join('tmp/maintenance.yml')).to exist
      end

      it 'can visit' do
        visit root_path
        expect(page).to have_no_content 'Service Unavailable'
      end
    end

  end

  describe 'stop' do
    before :each do
      allow_any_instance_of(MaintenanceHelper).to receive(:restart_server) do
        Rails.application.config.x.maintenance.enable = false
        Rails.application.config.x.maintenance.allow_ips = []
      end
    end

    let!(:task) { Rake.application['maintenance:stop'] }

    it 'executed' do
      expect(task.invoke).to be_truthy
      expect(Rails.root.join('tmp/maintenance.yml')).not_to exist
    end

    it 'can visit' do
      visit root_path
      expect(page).to have_no_content 'Service Unavailable'
    end

  end

end
