require 'yaml'

namespace :maintenance do
  task start: :environment do
    FileUtils.cp('config/maintenance.yml', 'tmp/maintenance.yml')
  end

  task end: :environment do
    FileUtils.rm('tmp/maintenance.yml')
  end
end
