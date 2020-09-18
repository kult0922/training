namespace :maintenance do
  desc "Start maintenance."
  task :start do
    unless File.exists?('tmp/maintenance.yml')
      File.open('tmp/maintenance.yml', 'w+') do |f|
        f.write('status: under maintenance')
      end
    end
  end

  desc "Stop maintenance."
  task :stop do
    if File.exists?('tmp/maintenance.yml')
      File.delete('tmp/maintenance.yml')
    end
  end
end
