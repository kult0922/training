class EnableMaintenanceModeBatch
  def self.execute
    AppSetting.enable_maintenance_mode
  end
  EnableMaintenanceModeBatch.execute
end
