namespace :maintenance do

  top_level = self
  using Module.new {
    refine(top_level.singleton_class) do
      def file_setting
        @yml = YAML.load_file('config/maintenance.yml')
        @logger = Logger.new(@yml['path']['log'])
      end
    end
  }

  desc 'start maintenance'
  task start: :environment do
    file_setting
    if File.exist?(@yml['path']['lock'])
      @logger.info('maintenance 進行中')
    else
      File.open(@yml['path']['lock'], 'w') do |f|
        f.write('maintenance: true')
      end
      @logger.info('maintenance 開始')
    end
  end

  desc 'end maintenance'
  task finish: :environment do
    file_setting
    if File.exist?(@yml['path']['lock'])
      File.delete(@yml['path']['lock'])
      @logger.info('maintenance 終了')
    else
      @logger.info('maintenance 進行中')
    end
  end
end
