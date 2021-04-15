# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe 'maintenance' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require('maintenance', [Rails.root.join('lib', 'tasks')])
    Rake::Task.define_task(:environment)
  end

  context 'start' do
    subject { @rake['maintenance:start'].execute }

    example 'exist maintenance.html.erb' do
      subject
      expect(File.file?('./app/views/maintenance.html.erb')).to match(true)
    end
  end

  context 'end' do
    subject { @rake['maintenance:end'].execute }

    example 'exist _maintenance.html.erb' do
      subject
      expect(File.file?('./app/views/_maintenance.html.erb')).to match(true)
    end
  end
end
