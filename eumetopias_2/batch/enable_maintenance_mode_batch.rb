class EnableMaintenanceModeBatch
  def self.execute
    ENV["MAINTENANCE_MODE"] = 'true'
  end
  EnableMaintenanceModeBatch.execute
end
