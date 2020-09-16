class EnableMaintenanceModeBatch
  def self.execute
    File.open(Rails.root.join("tmp/is_maintenance_mode"), "w") do |io|
      io.puts "is_maintenance_mode"
    end
  end
  EnableMaintenanceModeBatch.execute
end
