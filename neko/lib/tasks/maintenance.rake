namespace :maintenance do
  desc 'maintenance'
  task :start do
    unless File.exist?('tmp/maintenance.txt')
      File.open('tmp/maintenance.txt', 'w') do |f|
        f.write('')
      end
      puts 'Maintenance begins.'
    else
      puts "It's already under maintenance."
    end
    
  end

  task :finish do
    if File.exist?('tmp/maintenance.txt')
      File.delete('tmp/maintenance.txt')
      puts 'Maintenance is over.'
    else
      puts "It's not under maintenance."
    end
  end
end
