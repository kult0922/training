module Batches::MaintenanceLogger
  # モジュールもクラスのインスタンスなので「class << self」 とできる。
  class << self
    delegate(
      :debug,
      :info,
      :warn,
      :error,
      :fatal,
      to: :logger
    )

    def logger
      @logger ||= begin
        # 専用のログファイル出力用のLoggerオブジェクトを作成。
        logger = ActiveSupport::Logger.new(Rails.root.join('log', "batch_#{Rails.env}.log"))
        # ロガーのフォーマット文字列を扱うクラスからインスタンスを生成。
        logger.formatter = Logger::Formatter.new
        # ログの日時フォーマットをセットする。
        logger.datetime_format = '%Y-%m-%d %H:%M:%S'

        # ログを標準出力に出す
        srdout_logger = ActiveSupport::Logger.new(STDOUT)
        # 複数のログを出力する機能を備えたモジュールオブジェクトを作成。
        multiple_loggers = ActiveSupport::Logger.broadcast(srdout_logger)
        # multiple_loggersの機能をloggerオブジェクトに追加する。
        logger.extend(multiple_loggers)

        logger
      end
    end
  end
end