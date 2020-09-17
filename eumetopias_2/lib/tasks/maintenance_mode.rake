namespace :maintenance_mode do
  desc "enabling maintenance mode"
  task :enable => :environment do
    File.open(Rails.root.join("tmp/is_maintenance_mode"), "w") do |io|
      io.puts "do not erase this file manuall]]y"
    end
  end

  desc "disabling maintenance mode"
  task :disable => :environment do
    FileUtils.rm(Rails.root.join("tmp/is_maintenance_mode"))
  end
end
