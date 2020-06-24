namespace :maintenance do
  desc "start maintenance mode"
  task :start do
    unless File.exist?('tmp/maintenace.yml')
      mode = {mode: :on}
      YAML.dump(mode, File.open('tmp/maintenance.yml', 'w'))
      puts 'on'
    end
  end

  desc "end maintenance mode"
  task :end do
    File.delete('tmp/maintenance.yml')
    puts 'off'
  end

end
