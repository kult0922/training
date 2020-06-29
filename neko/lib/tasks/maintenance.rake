namespace :maintenance do
  desc 'maintenance'
  task start: :environment do
    if File.exist?('tmp/maintenance.txt')
      puts "It's already under maintenance."
    else
      File.open('tmp/maintenance.txt', 'w') do |f|
        f.write('')
      end
      puts 'Maintenance begins.'
    end
  end

  task finish: :environment do
    if File.exist?('tmp/maintenance.txt')
      File.delete('tmp/maintenance.txt')
      puts 'Maintenance is over.'
    else
      puts "It's not under maintenance."
    end
  end
end
