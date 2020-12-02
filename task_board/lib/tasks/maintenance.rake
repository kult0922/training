require 'yaml'

namespace :maintenance do
  desc 'start maintenance mode'
  task start: :environment do
    unless File.exist?('tmp/maintenance.yml')
      data = { 'allowed_ips' => %w[127.0.0.1] }
      YAML.dump(data, File.open('tmp/maintenance.yml', 'w+'))
    end
  end

  desc 'finish maintenance mode'
  task end: :environment do
    FileUtils.rm('tmp/maintenance.yml')
  end
end
