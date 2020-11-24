namespace :maintenance do
  task :start do
    c_file = Rails.root.join('config/maintenance.yml')
    m_file = Rails.root.join('tmp/maintenance.yml')
    pid_file = Rails.root.join('tmp/pids/server.pid')
    if c_file.exist?
      system "cp #{c_file} #{m_file}"
    else
      system "touch #{m_file}"
    end
    system "kill -s USR2 $(cat #{pid_file})"
  end

  task :stop do
    m_file = Rails.root.join('tmp/maintenance.yml')
    pid_file = Rails.root.join('tmp/pids/server.pid')

    if m_file.exist?
      system "rm #{m_file}"
    end

    system "kill -s USR2 $(cat #{pid_file})"
  end
end
