require 'rails_helper'

describe 'rake task csv' do
  let!(:start) { Rake.application['maintenance:start'] }
  let!(:finish) { Rake.application['maintenance:finish'] }
  let!(:file) { 'tmp/maintenance.txt' }

  describe 'start' do
    it 'create tmp/maintenance,txt' do
      start.execute
      expect(File).to exist(file)
      File.delete(file) if File.exist?(file)
    end
  end

  describe 'finish' do
    it 'delete tmp/maintenance,txt' do
      start.execute
      finish.execute
      expect(File).not_to exist(file)
    end
  end
end
