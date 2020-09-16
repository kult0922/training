class DisableMaintenanceModeBatch
  def self.execute
    FileUtils.rm(Rails.root.join("tmp/is_maintenance_mode"))
  end
  DisableMaintenanceModeBatch.execute
end
