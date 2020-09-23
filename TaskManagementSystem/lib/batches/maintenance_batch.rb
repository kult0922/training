class Batches::MaintenanceBatch
  def self.start
    return Batches::MaintenanceLogger.error('メンテナンス中。。。') if FileTest.exist?(MAINTENANCE_FILE_PATH)
    data = { start_time: Time.current }
    YAML.dump(data, File.open(MAINTENANCE_FILE_PATH, 'w'))
  end

  def self.end
    return Batches::MaintenanceLogger.info('メンテナンス終了') unless FileTest.exist?(MAINTENANCE_FILE_PATH)
    File.delete(MAINTENANCE_FILE_PATH)
  end
end