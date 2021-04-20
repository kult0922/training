namespace :maintenance do
  MANINTENANCE_FILE = 'tmp/maintenance.txt'

  desc 'maintenance mode on/off'

  task :on do
    unless File.exist?(MANINTENANCE_FILE)
      File.open(MANINTENANCE_FILE, 'w') { |f| f.write "#{Time.current}"}
      puts 'maintenance mode is on' 
    else
      puts 'maintenance mode is already on' 
    end
  end

  task :off do
    if File.exist?(MANINTENANCE_FILE)
      puts 'maintenance mode is off'
      File.delete(MANINTENANCE_FILE)
    else
      puts 'no available maintenance'
    end
  end
end
