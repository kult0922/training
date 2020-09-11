# frozen_string_literal: true

require 'rails_helper'
require 'rake_helper'

describe 'maintenence' do
  subject(:start) { Rake.application['maintenance:start'] }
  subject(:finish) { Rake.application['maintenance:finish'] }
  let(:file) { 'tmp/maintenance.yml' }

  context 'when start maintenance mode' do
    it 'tmp/maintenance.yml file created' do
      expect { start.invoke }.to change { File.exist?(file) }.from(be_falsey).to(be_truthy)
      File.delete(file) if File.exist?(file)
    end
  end

  context 'when finish maintenance mode' do
    it 'tmp/maintenance.yml file deleted' do
      start.invoke
      expect { finish.invoke }.to change { File.exist?(file) }.from(be_truthy).to(be_falsey)
    end
  end
end
