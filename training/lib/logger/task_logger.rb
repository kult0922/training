class Logger::TaskLogger
  attr_reader :logger

  delegate(
    :debug,
    :info,
    :warn,
    :error,
    :fatal,
    to: :logger,
  )

  def initialize(log_name)
    @logger =  ActiveSupport::Logger.new(Rails.root.join('log', "#{log_name}.log"))
    @logger.formatter = ::Logger::Formatter.new
    logger.datetime_format = '%Y-%m-%d %H:%M:%S'
  end
end
