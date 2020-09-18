class Batchs::MaintenanceBatch
  def self.start
    puts "メンテナンス開始"
    data = { start_time: Time.current }
    YAML.dump(data, File.open(MAINTENANCE_FILE_PATH, 'w'))
  end

  def self.end
    puts "メンテナンス終了"
    File.delete(MAINTENANCE_FILE_PATH)
  end
end