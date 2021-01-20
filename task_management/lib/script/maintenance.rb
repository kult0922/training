# frozen_string_literal: true

# メンテナンスモードに切り替えるバッチ
# ■呼び出し方
# rails runner lib/script/maintenance.rb [第一引数]
# ■第一引数
# 1:メンテナンス開始
# 0:メンテナンス終了
class Maintenance
  def self.execute
    mode = ARGV[0]
    switching(mode)
  end

  def self.switching(mode)
    return puts I18n.t('script.maintenance.error.no_arguments') if mode.blank?

    case mode
    when '1' then
      puts I18n.t('script.maintenance.success.start')
      write_maintenance_file(mode)
      puts I18n.t('script.maintenance.success.started')
    when '0' then
      puts I18n.t('script.maintenance.success.finish')
      write_maintenance_file(mode)
      puts I18n.t('script.maintenance.success.finished')
    else
      puts I18n.t('script.maintenance.error.invalid_argument',
                  argument: mode)
    end
  end

  def self.write_maintenance_file(mode)
    maintenance_file = File.open(Settings.maintenance[:file], 'w')
    maintenance_file.puts(mode)
    maintenance_file.close
  end
end

Maintenance.execute
