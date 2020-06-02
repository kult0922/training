namespace :maintenance do
  desc 'maintenance'
  task :start do
    unless File.exist?('tmp/maintenance.txt')
      File.open('tmp/maintenance.txt', 'w') do |f|
        f.write('')
      end
    end
    puts 'Maintenance begins.'
  end

  task :finish do
    puts 'Maintenance is over.'
    File.delete('tmp/maintenance.txt')
  end
end
