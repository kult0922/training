namespace :maintenance do
  desc 'start maintenance'
  yml = YAML.load_file('config/maintenance.yml')
  logger = Logger.new(yml['path']['log'])

  task start: :environment do
    if File.exist?(yml['path']['lock'])
      logger.info('maintenance 進行中')
    else
      File.open(yml['path']['lock'], 'w') do |f|
        f.write('maintenance: true')
      end
      logger.info('maintenance 開始')
    end
  end

  desc 'end maintenance'
  task finish: :environment do
    if File.exist?(yml['path']['lock'])
      File.delete(yml['path']['lock'])
      logger.info('maintenance 終了')
    else
      logger.info('maintenance 進行中')
    end
  end
end
