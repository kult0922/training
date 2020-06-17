# frozen_string_literal: true

require Rails.root.join('lib', 'logger', 'task_logger.rb')

namespace :maintenance do
  MAINTENANCE_DIR = Rails.root.join('tmp', 'maintenance')
  MAINTENANCE_FILE = Rails.root.join('tmp', 'maintenance', 'timing.yml')
  logger = TaskLogger.new('maintenance')

  desc 'set maintenance start_time and end_time'
  task :start, ['start_at', 'end_at'] do |_, args|
    if args.start_at.blank? || args.end_at.blank?
      logger.info 'メンテナンスの開始時間と終了時間を入力してください'
      p 'メンテナンスの開始時間と終了時間を入力してください'
      exit
    end

    if args.start_at.in_time_zone >= args.end_at.in_time_zone
      logger.info 'メンテナンスの終了時間は開始時間以降の時間を設定してください'
      p 'メンテナンスの終了時間は開始時間以降の時間を設定してください'
      exit
    end

    if args.start_at.in_time_zone < Time.current || args.end_at.in_time_zone <= Time.current
      logger.info 'メンテナンス時間は現在時刻より未来を入力してください'
      p 'メンテナンス時間は現在時刻より未来を入力してください'
      exit
    end

    if File.exist?(MAINTENANCE_FILE)
      data = File.open(MAINTENANCE_FILE, 'r') { |file| YAML.safe_load(file) }
      if data['end_at'].in_time_zone <= Time.current
        FileUtils.rm(MAINTENANCE_FILE)
      else
        logger.info '前回のメンテナンスが終了しておりません。前回のメンテナンスを終了させる場合はrake maintetance:endを実行してください'
        p '前回のメンテナンスが終了しておりません。前回のメンテナンスを終了させる場合はrake maintetance:endを実行してください'
        exit
      end
    end

    Dir.mkdir(MAINTENANCE_DIR) unless Dir.exist?(MAINTENANCE_DIR)
    data = { 'start_at' => args.start_at, 'end_at' => args.end_at }
    YAML.dump(data, File.open(MAINTENANCE_FILE, 'w'))

    logger.info "メンテナンス開始時間を#{args.start_at} ~ #{args.end_at}で設定しました"
    p "メンテナンス開始時間を#{args.start_at} ~ #{args.end_at}で設定しました"
  end

  desc 'end maintenance'
  task :end do
    FileUtils.rm(MAINTENANCE_FILE)
    logger.info 'メンテナンスを終了しました'
    p 'メンテナンスを終了しました'
  end
end
