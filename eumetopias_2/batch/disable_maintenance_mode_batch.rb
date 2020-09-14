class DisableMaintenanceModeBatch
  def self.execute
    AppSetting.disable_maintenance_mode
  end
  DisableMaintenanceModeBatch.execute
end
