namespace :maintenance do
  desc 'start maintenance mode'
  task :start do
    logger = Logger.new('log/maintenance.log')
    logger.info('タスクを起動しています')
    unless File.exist?('tmp/maintenance.yml')
      mode = { mode: :on }
      YAML.dump(mode, File.open('tmp/maintenance.yml', 'w'))
      logger.info('メンテナンスモードが正常に開始されました')
    end
  end

  desc 'end maintenance mode'
  task :end do
    logger = Logger.new('log/maintenance.log')
    logger.info('タスクを起動しています')
    next unless File.exist?('tmp/maintenance.yml')
    File.delete('tmp/maintenance.yml')
    logger.info('メンテナンスモードが正常に終了しました')
  end
end
