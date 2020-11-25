module MaintenanceHelper

  def restart_server
    pid_file = Rails.root.join('tmp/pids/server.pid')
    system "kill -s USR1 $(cat #{pid_file})"
  end

end
