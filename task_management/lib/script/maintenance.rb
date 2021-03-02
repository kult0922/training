# frozen_string_literal: true

# メンテナンスモードに切り替えるバッチ
# ■呼び出し方
# rails runner lib/script/maintenance.rb [第一引数]
# ■第一引数
# 1:メンテナンス開始
# 0:メンテナンス終了
class Maintenance
  cattr_accessor :logger
  self.logger ||= Rails.logger

  def self.execute
    mode = ARGV[0]
    switching(mode)
  end

  def self.switching(mode)
    return logger.info I18n.t('script.maintenance.error.no_arguments') if mode.blank?

    case mode
    when Settings.maintenance[:start] then
      logger.info I18n.t('script.maintenance.success.start')
      write_maintenance_file(mode)
      logger.info I18n.t('script.maintenance.success.started')
    when Settings.maintenance[:end] then
      logger.info I18n.t('script.maintenance.success.finish')
      write_maintenance_file(mode)
      logger.info I18n.t('script.maintenance.success.finished')
    else
      logger.info I18n.t('script.maintenance.error.invalid_argument', argument: mode)
    end
  end

  def self.write_maintenance_file(maintenance_mode)
    maintenance_file = File.open(Settings.maintenance[:file_path], 'w')
    maintenance_file.print(maintenance_mode)
    maintenance_file.close
  end
end

Maintenance.execute
