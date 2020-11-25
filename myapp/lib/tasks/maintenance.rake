require "#{Rails.root}/app/helpers/maintenance_helper"
include MaintenanceHelper

namespace :maintenance do
  task :start do
    c_file = Rails.root.join('config/maintenance.yml')
    m_file = Rails.root.join('tmp/maintenance.yml')

    if c_file.exist?
      system "cp #{c_file} #{m_file}"
    else
      system "touch #{m_file}"
    end

    restart_server
  end

  task :stop do
    m_file = Rails.root.join('tmp/maintenance.yml')
    pid_file = Rails.root.join('tmp/pids/server.pid')

    if m_file.exist?
      system "rm #{m_file}"
    end

    restart_server
  end
end
