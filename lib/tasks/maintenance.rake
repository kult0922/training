# frozen_string_literal: true

namespace :maintenance do
  desc 'Move our service to maintenance mode'
  task on: :environment do
    FileUtils.touch(MAINTENANCE_FILE_NAME)
  end

  desc 'Return from maintenance mode'
  task off: :environment do
    FileUtils.remove(MAINTENANCE_FILE_NAME, force: true)
  end
end
