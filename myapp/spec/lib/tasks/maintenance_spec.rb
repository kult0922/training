require 'rails_helper'
require 'rake_helper'

describe 'maintenence' do
  subject(:on) { Rake.application['maintenance:start'] }
  subject(:off) { Rake.application['maintenance:end'] }
  let(:maintenance_file) { 'tmp/maintenance.yml' }

  context 'when maintenance mode is on' do
    it 'tmp file is exist' do
      expect { on.invoke }.to change { File.exist?(maintenance_file) }.from(be_falsey).to(be_truthy)
      File.delete(maintenance_file)
    end
  end

  context 'when maintenance mode is off' do
    it 'tmp file is not exist' do
      on.invoke
      expect { off.invoke }.to change { File.exist?(maintenance_file) }.from(be_truthy).to(be_falsey)
    end
  end
end
